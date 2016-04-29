require "rack_http_preload/version"
require "uri"

module RackHttpPreload
  def http_preload path = nil, crossorigin: false, push: false, as: nil, type: nil
    as, type = guess_http_preload_opts(path) if (as.nil? && type.nil?)

    header = ["<#{path}>", "rel=preload"]
    header << "as=#{as}" if as
    header << "crossorigin" if crossorigin
    header << "nopush" if push
    header << "type='#{type}'" if type

    add_to_link_header header.join("; ")
  end

  private

  def add_to_link_header link
    links = (response.headers['Link'] || "").split(',').map(&:strip)
    links << link
    response.headers["Link"] = links.join(', ') unless links.empty?
  end

  def guess_http_preload_opts path
    return nil unless defined? MIME::Types

    resource = URI(path).path.split('/').last
    mimetypes = MIME::Types.type_for(resource).map(&:content_type).join(" ")

    as = case mimetypes
    when /javascript/
      :script
    when /css/
      :style
    when /image/
      :image
    when /font/
      :font
    when /audio/
      :audio
    when /video/
      :video
    end

    type = if %i[font audio video].include?(as)
      MIME::Types.type_for(resource).first.content_type
    end

    [as, type]
  end
end
