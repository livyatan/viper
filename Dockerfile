FROM killercentury/ruby-phantomjs-onbuild
COPY viper.rb .
ENV COUCH http://localhost:5984
CMD bundle exec ruby viper.rb
