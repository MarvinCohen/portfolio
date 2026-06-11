# test_helper.rb — configuration commune à tous les tests (minitest).
# Ce fichier est chargé au début de chaque test.
ENV["RAILS_ENV"] ||= "test"
require_relative "../config/environment"
require "rails/test_help"

module ActiveSupport
  class TestCase
    # Lance les tests en parallèle sur plusieurs cœurs pour aller plus vite
    parallelize(workers: :number_of_processors)
  end
end
