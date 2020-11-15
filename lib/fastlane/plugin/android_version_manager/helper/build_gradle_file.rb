
class BuildGradleFile
  def initialize(app_project_dir)
    @app_project_dir = app_project_dir
  end

  def find
    if kts_exists?
      return kts
    end
    return classic
  end

  def exists?
    return kts_exists? || classic_exists?
  end

  def kts_exists?
    return file_exists?(kts)
  end

  def classic_exists?
    return file_exists?(classic)
  end

  def kts
    return "#{@app_project_dir}/build.gradle.kts"
  end

  def classic
    return "#{@app_project_dir}/build.gradle"
  end

  def file_exists?(path)
    # Not using File.exist? because it does not handle globs
    return Dir[path].any?
  end
end
