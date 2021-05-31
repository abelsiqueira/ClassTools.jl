"""
# ClassTools

Tools for handling GitHub classroom exercises.
"""
module ClassTools

using CSV, DataFrames, Git

export add_remote, download_assignment, fix_origin, merge_changes, pick_changes, push_changes, validate

"""
    download_assignment(repo, prefix, file)

Download assignment manually, from url:

    https://github.com/\$repo/\$prefix-\$student.git

The `student` keyword is obtained from a `classroom_roster.csv` `file`.
"""
function download_assignment(repo, prefix, file)
  df = CSV.read(file, DataFrame)
  for row in eachrow(df)
    student = row.github_username
    print("$student ")
    url = "https://github.com/$repo/$prefix-$student.git"
    try
      isdir(prefix) || mkdir(prefix)
      run(`git clone $url $prefix/$student`)
      printstyled("✓\n", color=:green)
    catch ex
      printstyled("×", color=:red)
      println(" $ex")
    end
  end
end


"""
    validate()

Validate folder structure.
Currently checks for:
- Whether the folders have .git folders.
"""
function validate()
  for d in readdir()
    cd(d) do
      print("$d ")
      if !(
        isdir(".git")
      )
        printstyled("×", color=:red)
      else
        printstyled("✓", color=:green)
      end
      println("")
    end
  end
end

"""
    fix_origin(repo, prefix)

After download with the Classroom-Assistant, the origin remotes are read-only.
This will change the remote to

    https://github.com/\$repo/\$prefix-DIR.git
"""
function fix_origin(repo, prefix)
  for d in readdir()
    cd(d) do
      url = "https://github.com/$repo/$prefix-$d.git"
      print("$d ")
      try
        Git.run(`remote set-url origin $url`)
        Git.run(`fetch origin`)
        printstyled("✓\n", color=:green)
      catch ex
        printstyled("×", color=:red)
        println(" $ex")
      end
    end
  end
end

"""
    add_remote(ex_remote)

Assuming validated folder structure, enter each folder and add a remote given by `ex_remote`, which should be the template of the exercise.
The remote will be called `exercise`.
"""
function add_remote(ex_remote)
  for d in readdir()
    cd(d) do
      print("$d ")
      try
        Git.run(`remote add exercise $ex_remote`)
        Git.run(`fetch exercise`)
        printstyled("✓\n", color=:green)
      catch ex
        printstyled("×", color=:red)
        println(" $ex")
      end
    end
  end
end

"""
    merge_changes()

Assuming validated folder structure and remote `exercise` present.
Merge `exercise/master` into `master`.
"""
function merge_changes(;msg = "Merge template changes")
  for d in readdir()
    cd(d) do
      print("$d ")
      try
        Git.run(`checkout master`)
        Git.run(`merge exercise/master master -m "$msg"`)
        printstyled("✓\n", color=:green)
      catch ex
        printstyled("×", color=:red)
        println(" $ex")
      end
    end
  end
end

"""
    pick_changes(commit)

Assuming validated folder structure and remote `exercise` present.
Cherry-pick `exercise/master` into `master`.
"""
function pick_changes(cmt)
  for d in readdir()
    cd(d) do
      print("$d ")
      try
        Git.run(`checkout master`)
        Git.run(`cherry-pick $cmt`)
        printstyled("✓\n", color=:green)
      catch ex
        printstyled("×", color=:red)
        println(" $ex")
      end
    end
  end
end

"""
    push_changes()

Assuming validated folder structure and remote `exercise` present.
Push changes from `master` to the `origin` folder.
"""
function push_changes()
  for d in readdir()
    cd(d) do
      print("$d ")
      try
        Git.run(`push origin master`)
        printstyled("✓\n", color=:green)
      catch ex
        printstyled("×", color=:red)
        println(" $ex")
      end
    end
  end
end

end # module