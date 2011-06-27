# Be sure to restart your server when you modify this file.

# Your secret key for verifying cookie session data integrity.
# If you change this key, all old sessions will become invalid!
# Make sure the secret is at least 30 characters and all random, 
# no regular words or you'll be exposed to dictionary attacks.
ActionController::Base.session = {
  :key         => '_thinkprojects_session',
  :secret      => '9fe3b7c7c5f627ed47b23d1047669f93009e1da804975751ade190fbe00e0a3f4810d6497b2e1ae1b32c3faf261ef379e547a148c92dd2bb6239ddfd740d97b4'
}

# Use the database for sessions instead of the cookie-based default,
# which shouldn't be used to store highly confidential information
# (create the session table with "rake db:sessions:create")
# ActionController::Base.session_store = :active_record_store
