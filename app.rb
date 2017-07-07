require 'sinatra'
require 'json'

require 'pry'

get '/' do
  'Awake!'
end

post /.*/ do |route|
  logger.info "POST received at #{route}"

  begin
    post_headers = %i(content_type request_method).map do |header_key|
      { header_key => request.send(header_key) }
    end.reduce(:merge)

    request_body = request.body.read
    post_body    = JSON.parse(request_body) rescue request_body
  rescue => e
    logger.info "Could not parse POST body: #{e.message}"
  end

  post_headers ||= { error: 'there was an error retrieving post headers' }
  post_body ||= { error: 'there was an error reading the post body' }
  response_body = { route: params[:route] }.merge(post_headers).merge({ request_body: post_body })

  logger.info response_body

  response.write response_body.to_json
end
