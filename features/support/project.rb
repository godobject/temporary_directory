module Project
  def project_root_directory
    @project_root_directory ||= Pathname.new(__dir__) / '..' / '..'
  end
end

World(Project)
