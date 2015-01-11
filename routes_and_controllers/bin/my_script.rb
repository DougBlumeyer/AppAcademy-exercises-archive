require 'addressable/uri'
require 'rest-client'

def create_user
  url = Addressable::URI.new(
    scheme: 'http',
    host: 'localhost',
    port: 3000,
    path: '/users.json'
  ).to_s

  puts RestClient.post(
    url,
    { user: { name: "Gizmo", email: "gizmo@gizmo.gizmo" } }
  )
end

def test
  url = Addressable::URI.new(
    scheme: 'http',
    host: 'localhost',
    port: 3000,
    path: '/users.html'
    # query_values: {
    #   'favorite_things[:animal][:mammal]' => 'lion',
    #   'favorite_things[:animal][:bird]' => 'parrot'
    # }
  ).to_s

  puts RestClient.get(url)

  #puts RestClient.post(url, { user: { id: 1 } })
end

def update_user
  url = Addressable::URI.new(
  scheme: 'http',
  host: 'localhost',
  port: 3000,
  path: '/users/1.json'
  ).to_s

  puts RestClient.put(
    url,
    { user: { email: 'microsoft@bob.com' } }
  )
end

def delete_user
  url = Addressable::URI.new(
    scheme: 'http',
    host: 'localhost',
    port: 3000,
    path: '/users/3.json'
  ).to_s

  puts RestClient.delete(url)
end
