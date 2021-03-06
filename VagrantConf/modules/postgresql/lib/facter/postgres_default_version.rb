def get_debianfamily_postgres_version
  case Facter.value('operatingsystem')
    when "Debian"
      get_debian_postgres_version()
    when "Ubuntu"
      get_ubuntu_postgres_version()
    else
      nil
  end
end

def get_debian_postgres_version
  case Facter.value('operatingsystemrelease')
    # TODO: add more debian versions or better logic here
    when /^6\./
      "8.4"
    when /^wheezy/
      "9.1"
    else
      nil
  end
end

def get_ubuntu_postgres_version
  case Facter.value('operatingsystemrelease')
    # TODO: add more ubuntu versions or better logic here
    when "12.10"
      "9.1"
    when "12.04"
      "9.1"
    when "10.04"
      "8.4"
    else
      nil
  end
end

def get_redhatfamily_postgres_version
  case Facter.value('operatingsystemrelease')
    when /^6\./
      "8.4"
    when /^5\./
      "8.1"
    else
      nil
  end
end

Facter.add("postgres_default_version") do
  setcode do
    result =
      case Facter.value('osfamily')
        when 'RedHat'
          get_redhatfamily_postgres_version()
        when 'Linux'
          get_redhatfamily_postgres_version()
        when 'Debian'
          get_debianfamily_postgres_version()
        else
          nil
      end

    # TODO: not sure if this is really a great idea, but elsewhere in the code
    # it is useful to be able to distinguish between the case where the fact
    # does not exist at all (e.g., if pluginsync is not enabled), and the case
    # where the fact is not known for the OS in question.  It might be better
    # to use a shorter sentinel value here and then check for it elsewhere,
    # e.g. in the same place we're checking for nil and warning about pluginsync.
    if result == nil
      result = "Unsupported OS!  Please check `postgres_default_version` fact."
    end
    result
  end
end
