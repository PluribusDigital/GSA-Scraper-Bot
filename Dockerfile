FROM ruby:2.3.3

# switch to root user to enable install & file actions
# USER root

# Install Ruby & related dependencies
# RUN apt-get update && apt-get install -y ruby
# RUN apt-get install -y ruby-dev
# RUN apt-get install -y build-essential
# RUN apt-get install -y zlib1g-dev

# Setup & map working dir
RUN mkdir /home/myapp
WORKDIR /home/myapp
ADD . /home/myapp

# Switch to normal selenium user (see also source image)
# USER seluser

# install ruby test libraries
RUN gem install bundler && bundle install --jobs 20 --retry 5

CMD ["bundle", "exec", "cucumber"]
