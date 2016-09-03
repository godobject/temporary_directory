module SubsequentTemporaryDirectoryRootDirectory
  attr_reader :subsequent_temporary_directory_root_directory

  def create_root_for_subsequent_temporary_directories
    @subsequent_temporary_directory_root_directory = temporary_directory / 'subsequent_temporary_directories'
    @subsequent_temporary_directory_root_directory.mkpath
    @subsequent_temporary_directory_root_directory
  end
end

World(SubsequentTemporaryDirectoryRootDirectory)
