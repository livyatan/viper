FROM killercentury/ruby-phantomjs-onbuild
COPY viper.rb .
ENV COUCH
CMD bundle exec ruby viper.rb
