Feature: Temporary directories for RSpec examples

  Scenario: Create a directory for each example
    Given a file called "temporary_directory_spec.rb" with the following content:
    """
      require 'temporary_directory'

      describe 'something' do
        include GodObject::TemporaryDirectory::Helper.new

        before(:example) { ensure_presence_of_temporary_directory }

        specify { expect(123).to be_a Numeric }
        specify { expect('abc').to be_a String }
        specify { expect(temporary_directory).to exist }
      end
    """
    When I run "rspec temporary_directory_spec.rb"
    Then all examples should pass
    And 3 temporary directories remain

  Scenario: Create directories just on demand
    Given a file called "temporary_directory_spec.rb" with the following content:
    """
      require 'temporary_directory'

      describe 'something' do
        include GodObject::TemporaryDirectory::Helper.new

        specify { expect(123).to be_a Numeric }
        specify { expect('abc').to be_a String }
        specify do
          expect(temporary_directory).to exist
          expect(temporary_directory).to be_a_directory
        end
      end
    """
    When I run "rspec temporary_directory_spec.rb"
    Then all examples should pass
    And one temporary directory remains

  Scenario: Create directories with specific name prefixes
    Given a file called "temporary_directory_spec.rb" with the following content:
    """
      require 'temporary_directory'

      describe 'something' do
        include GodObject::TemporaryDirectory::Helper.new(name_prefix: 'marker')

        before(:example) { ensure_presence_of_temporary_directory }

        specify { expect(123).to be_a Numeric }
      end
    """
    When I run "rspec temporary_directory_spec.rb"
    Then all examples should pass
    And the remaining temporary directories start with "marker"

  Scenario: Delete directories afterwards
    Given a file called "temporary_directory_spec.rb" with the following content:
    """
      require 'temporary_directory'

      describe 'something' do
        include GodObject::TemporaryDirectory::Helper.new

        after(:example) { ensure_absence_of_temporary_directory }

        specify { expect(123).to be_a Numeric }
        specify { expect('abc').to be_a String }

        describe 'temporary directory' do
          subject { temporary_directory }

          it { is_expected.to exist }

          describe 'sub-directory' do
            let(:sub_directory) do
              directory = temporary_directory / 'sub'
              directory.mkpath
              directory
            end

            specify { expect(sub_directory).to exist }
          end
        end
      end
    """
    When I run "rspec temporary_directory_spec.rb"
    Then all examples should pass
    And no temporary directories remain

