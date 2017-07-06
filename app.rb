require 'sinatra'
require 'json'

post '/:route' do |route|
  logger.info "POST received at #{route}"

  begin
    post_params  = JSON.parse(request.body.read)
    post_headers = %i(content_type request_method)
  rescue => e
    logger.info "Could not parse POST body: #{e.message}"
  end

  post_params ||= {}
  post_headers ||= {}
  response_body = post_headers.merge(params).merge(post_params)

  logger.info response

  response.write response_body.to_s
end
