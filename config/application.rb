require_relative 'boot'

require 'rails/all'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module RailsRecipes
  class Application < Rails::Application
    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration should go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded.
    #设置默认使用的语言
    config.i18n.default_locale = "zh-CN"

    #设置默认的时区
    config.time_zone = "Beijing"

    #添加table tr td标签到sanitize白名单中
    config.action_view.sanitized_allowed_tags = Rails::Html::WhiteListSanitizer.allowed_tags + %w(table tr td)

    #添加style border标签到sanitize白名单中
    config.action_view.sanitized_allowed_attributes = Rails::Html::WhiteListSanitizer.allowed_attributes + %w(style border)

    #设置默认的时间格式以及只显示年月日的时间格式ymd
    Time::DATE_FORMATS.merge!(default: "%Y/%m/%d %I:%M %p", ymd: "%Y/%m/%d")
  end
end
