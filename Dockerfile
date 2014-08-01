FROM ubuntu:14.04

MAINTAINER Simon Caplette https://github.com/simcap

ENV HOME /root

RUN apt-get update && apt-get upgrade -y && apt-get clean && rm -fr /var/cache/apt/archives/*
RUN apt-get install -y build-essential unzip make gcc wget git curl zlib1g-dev libssl-dev libreadline-dev libyaml-dev libxml2-dev libxslt-dev

RUN wget -P /root/src ftp://ftp.ruby-lang.org/pub/ruby/2.1/ruby-2.1.2.tar.gz
RUN cd /root/src; tar xvf ruby-2.1.2.tar.gz
RUN cd /root/src/ruby-2.1.2; ./configure; make install

RUN gem update --system
RUN gem install bundler

RUN cd /root; git clone https://github.com/simcap/cruchot_hq

WORKDIR /root/cruchot_hq
RUN bundle install

EXPOSE 9292

CMD ["bundle", "exec", "rackup"]
