Feature: Temporary directories for Cucumber

  Background:
    Given a file called "features/temporary_directory.feature" with the following content:
    """
      Feature: Something

        Scenario: Something specific
          Given some precondition
          When the temporary directory is referenced
          Then the state is somehow

        Scenario: Another thing
          Given some precondition
          When something else happens
          Then the state is somehow
    """
    And a file called "features/step_definitions/temporary_directory.rb" with the following content:
    """
      Given(/^some precondition$/) {}
      When(/^something else happens$/) {}

      When(/^the temporary directory is referenced$/) do
        temporary_directory
      end

      Then(/^the state is somehow$/) {}
    """

  Scenario: Create a directory for each example
    Given a file called "features/support/env.rb" with the following content:
    """
      require 'temporary_directory'

      World(GodObject::TemporaryDirectory::Helper.new)

      Before do
        ensure_presence_of_temporary_directory
      end
    """
    When I run "cucumber"
    Then all scenarios and their steps should pass
    And 2 temporary directories remain

  Scenario: Create directories just on demand
    Given a file called "features/support/env.rb" with the following content:
    """
      require 'temporary_directory'

      World(GodObject::TemporaryDirectory::Helper.new)
    """
    When I run "cucumber"
    Then all scenarios and their steps should pass
    And one temporary directory remains

  Scenario: Create directories with specific name prefixes
    Given a file called "features/support/env.rb" with the following content:
    """
      require 'temporary_directory'

      World(GodObject::TemporaryDirectory::Helper.new(name_prefix: 'marker'))
    """
    When I run "cucumber"
    Then all scenarios and their steps should pass
    And the remaining temporary directories start with "marker"

  Scenario: Delete directories afterwards
    Given a file called "features/support/env.rb" with the following content:
    """
      require 'temporary_directory'

      World(GodObject::TemporaryDirectory::Helper.new)

      After do
        ensure_absence_of_temporary_directory
      end
    """
    When I run "cucumber"
    Then all scenarios and their steps should pass
    And no temporary directories remain
