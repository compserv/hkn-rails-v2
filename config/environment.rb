# Load the Rails application.
require File.expand_path('../application', __FILE__)

# Initialize the Rails application.
HknRails::Application.initialize!

LDAP_SERVER = 'hkn.eecs.berkeley.edu'
LDAP_SERVER_PORT = 389