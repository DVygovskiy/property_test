require 'csv'
class Requester
  def initialize(api)
    @api = api
    @current_cookie = ''
  end

  def get(path:, referrer: '')
    result = @api.get(URI("#{Global.settings.base_url}/#{path}"),
                      :headers => set_header(referrer: referrer),
                      follow_redirects: true)
    set_cookie
    result
  end

  def post(path:, body: {}, content_type: '', referrer: '')
    unless path.include? "http"
      result = @api.post(
          URI("#{Global.settings.base_url}/#{path}"),
          :body => body,
          :headers => set_header(content_type: content_type, referrer: referrer),
          follow_redirects: true
      )
    else
      result = @api.post(
          URI("#{path}"),
          :body => body,
          :headers => set_header(content_type: content_type, referrer: referrer),
          follow_redirects: true
      )
    end
    set_cookie
    result
  end

  def find_value(where:, value: '_token')
    Nokogiri::HTML(where).xpath("//input[@name='#{value}']").attr('value').value
  end

  private

  def set_cookie
    @current_cookie = @api.cookies.map { |key, value| "#{key}=#{value}" }.join("; ")
  end

  def set_header(referrer: '', content_type: '')
    header = {'Accept' => 'text/html, application/xhtml+xml, */*'}
    header.merge! 'Cookie' => @current_cookie if @current_cookie.present?
    header.merge! 'Content-Type' => content_type if content_type.present?
    header.merge! 'Referer' => "#{Global.settings.base_url}/#{referrer}" if referrer.present?
    header
  end


end
