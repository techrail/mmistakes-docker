FROM ubuntu

# Set the PATH to allow directly running rbenv when using the shell
ENV PATH="${PATH}:/root/.rbenv/bin:/root/.rbenv/versions/3.1.2/bin"

# Set Language variables to ensure that jekyll build runs successfully
ENV LANG=C.UTF-8
ENV LC_CTYPE=C.UTF8

WORKDIR /app
COPY Gemfile /app/Gemfile

# Update ubuntu and install rbenv and compile and install Ruby version 3.1.2
RUN apt update && \
	apt upgrade -y && \
	apt install -y git curl wget zsh build-essential libz-dev autoconf bison patch rustc libssl-dev libyaml-dev libreadline6-dev zlib1g-dev libgmp-dev libncurses5-dev libffi-dev libgdbm6 libgdbm-dev libdb-dev uuid-dev && \
	git clone https://github.com/rbenv/rbenv.git ~/.rbenv && \
	git clone https://github.com/rbenv/ruby-build.git "$(~/.rbenv/bin/rbenv root)"/plugins/ruby-build && \
	~/.rbenv/bin/rbenv install -fv 3.1.2

# Install bundler and use it to install minimal-mistakes jekyll theme and dependencies
RUN ~/.rbenv/versions/3.1.2/bin/gem install bundler
RUN ~/.rbenv/versions/3.1.2/bin/bundler install

# Add rbenv init commands to allow running rbenv when using shell
RUN echo 'eval "$(~/.rbenv/bin/rbenv init - bash)"' >> ~/.bashrc
RUN echo 'eval "$(~/.rbenv/bin/rbenv init - bash)"' >> ~/.bash_profile

# Set just-installed ruby to be globally available
RUN rbenv global 3.1.2

# Copy script
COPY build_site.zsh /app/build_site.zsh

