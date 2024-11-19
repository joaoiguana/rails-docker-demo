# Use Ruby 3.1.2 to match your Gemfile
FROM ruby:3.1.2-slim

# Install essential packages
RUN apt-get update -qq && \
    apt-get install --no-install-recommends -y \
    build-essential \
    libpq-dev \
    nodejs && \
    rm -rf /var/lib/apt/lists/*

# Set the working directory
WORKDIR /app

# Copy Gemfile and install dependencies
COPY Gemfile Gemfile.lock ./

# Install gems without development/test dependencies
RUN bundle config set --local without 'development test' && \
    bundle install

# Copy the rest of the application
COPY . .

# asset precompilation
RUN bundle exec rake assets:precompile RAILS_ENV=production

# Expose port 3000
EXPOSE 3000

# Start the Rails server
CMD ["rails", "server", "-b", "0.0.0.0"]
