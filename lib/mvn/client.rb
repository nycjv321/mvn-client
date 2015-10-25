module Mvn
  class Client
    def initialize(path, artifact_id='')
      @path = path
      @artifact_id = artifact_id
    end

    def version=(version)
      if @artifact_id.empty?
        output = `cd #{@path}; mvn versions:set -DnewVersion=#{version}`
      else
        output = `cd #{@path + "/#{@artifact_id}"}; mvn versions:set -DnewVersion=#{version}`
      end
      unless output.include? 'BUILD SUCCESS'
        raise "Could not update mvn version see: #{output}"
      end

    end

    def version
      if @artifact_id.empty?
        `cd #{@path}; mvn -q -Dexec.executable="echo" -Dexec.args='${project.version}'  --non-recursive org.codehaus.mojo:exec-maven-plugin:1.3.1:exec`.chomp
      else
        `cd #{@path + "/#{@artifact_id}"}; mvn -q -Dexec.executable="echo" -Dexec.args='${project.version}'  --non-recursive org.codehaus.mojo:exec-maven-plugin:1.3.1:exec`.chomp
      end

    end

    def self.create(path, group_id='com.mcclatchy', artifact_id = 'test')
      unless Dir.exist? path
        Dir.mkdir path
      end
      output = `cd #{path}; mvn archetype:generate -DgroupId=#{group_id} -DartifactId=#{artifact_id} -DarchetypeArtifactId=maven-archetype-quickstart -DinteractiveMode=false`
      unless output.include? 'BUILD SUCCESS'
        raise(output)
      end
    end

  end
end
