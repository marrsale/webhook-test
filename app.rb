require 'sinatra'
require 'json'
require 'pry'

# Allow for waking of app if sleeping on Rackup VPS 
get '/' do
  'Awake!'
end

post /.*/ do
  route = request.path_info
  logger.info "POST received at #{route}"

  begin
    # Get the most basic request information to guarantee it's logged
    post_headers = {
      content_type: request.content_type,
      request_method: request.request_method
    }

    # Get out all HTTP header values from request
    http_headers = request.env.select do |key, value|
      not /HTTP_*/.match(key).nil?
    end rescue {}

    post_headers.merge! http_headers

    # Read and parse the body of the request if it is valid JSON
    request_body = request.body.read
    post_body    = JSON.parse(request_body) rescue request_body
  rescue => e
    logger.info "Could not parse request: #{e.message}"
  end

  post_headers ||= { error: 'there was an error retrieving post headers' }
  post_body ||= { error: 'there was an error reading the post body' }
  response_body = { route: route }.merge(post_headers).merge({ request_body: post_body })

  # Log what we care about
  logger.info response_body

  # Respond with JSON for debugging info on requester side
  response.write response_body.to_json
end
