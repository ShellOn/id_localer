require "i18n"
require 'action_dispatch/http/request'
require "rack/request"
require "pry"

#---- InfoDinamika Libraries ----
# id_localer v.0.0.1
#
# Give credit to the author of htttp_accept_language gem Iain Hecker
#
#   Author: ShellChen
#   Date:   10/07/2012
#
# Set the i18n.locale by checking the cookies.permanent[:locale],
# otherwise it will set the locale by the HTTP_ACCEPT_LANGUAGE header

module IdLocaler
  class Localer
     ACTION_DISPATCH_COOKIES = 'action_dispatch.cookies'.freeze
     PATH_INFO = 'PATH_INFO'.freeze
     HTTP_ACCEPT_LANGUAGE = 'HTTP_ACCEPT_LANGUAGE'.freeze

    def initialize(app)
      @app = app
      @i18n_locales = I18n.available_locales.collect { |l| l.to_s}
    end

    def call(env)
      locale = nil
      param_locale = nil
      path_info = env[PATH_INFO] 
      cookies = env[ACTION_DISPATCH_COOKIES]
      http_accept_language = env[HTTP_ACCEPT_LANGUAGE]
      #binding.pry


      if path_info && path_info != "/"
        puts path_info+"path_info session------------------"
        path_info_locale = (path_info.split("/") & @i18n_locales).first
        param_locale = path_info_locale if @i18n_locales.include?(path_info_locale)
      end
      if param_locale
        locale = param_locale
        cookies.permanent[:locale] = locale # write locale into the cookies
      elsif cookies && cookies[:locale] # TODO may do a @i18n_locales.include? check
        puts "Cookies #{cookies[:locale]}"
        locale = cookies[:locale]
      elsif locales = http_accept_language
        puts http_accept_language+"wwwwwwwwwwww"
        # detect the header
        locales = locales.split(/\s*,\s*/).collect do |l|
          l += ';q=1.0' unless l =~ /;q=\d+\.\d+$/
            l.split(';q=')
        end.sort do |x,y|
          raise "Not correctly formatted" unless x.first =~ /^[a-z\-0-9]+$/i
          y.last.to_f <=> x.last.to_f
        end.collect do |l|
          l.first.downcase.gsub(/-[a-z0-9]+$/i) { |x| x.upcase }
        end
        locale = locales.map do |x| #en-US
          @i18n_locales.find do |y| # en
            y = y.to_s
            x == y || x.split('-', 2).first == y.split('-', 2).first
          end
        end.compact.first
        cookies.permanent[:locale] = locale # write locale into the cookies
      else
        locale = I18n.default_locale
        cookies.permanent[:locale] = locale # write locale into the cookies
      end
      I18n.locale = locale
      s,h,b = @app.call(env)
      h['Content-Language'] = locale.to_s
      [s,h,b]
    end
  end
end
