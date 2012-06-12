require "i18n"

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
    def initialize(app)
      @app = app
    end

    def call(env)
      s,h,b = @app.call(env) # call the before middlewares for get the status, header, body and the new env
      params = env['action_dispatch.request.parameters']
      cookies = env['action_dispatch.cookies']
      locale = nil

      if params && locale = params[:locale] # put the routes into :locale scope in the config/routes.rb
        #Switch to a determine language
        if I18n.available_locales.include?(params[:locale])
          locale = params[:locale]
        else
          locale = I18n.default_locale
        end
        cookies.permanent[:locale] = locale # write locale into the cookies
      elsif cookies && cookies[:locale]
        #Cookies local checking
        locale = cookies[:locale]
      elsif locales = env['HTTP_ACCEPT_LANGUAGE']
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
        # Set the available languages in the i18n initialize file
        # Ex:
        # in config/initializers/locale.rb
        # 
        # I18n.available_locales = %w{ en zh es jp }
        #
        locale = locales.map do |x| #en-US
          I18n.available_locales.find do |y| # en
            y = y.to_s
            x == y || x.split('-', 2).first == y.split('-', 2).first
          end
        end.compact.first
        cookies.permanent[:locale] = locale # write locale into the cookies
      end
      locale = I18n.default_locale unless locale
      I18n.locale = locale.to_s
      h['Content-Language'] = locale.to_s
      [s,h,b]
    end
  end
end
