# Platform-dependent definitions of common commands.
#
# “ComSpec” on Windows is similar to the TERM environment variable. It
# indicates the path of cmd.exe. We don't care where cmd.exe is, but we
# _do_ care if we're running under it: it means that we'll be calling Windows
# shell builtins instead of POSIX homonyms, and need to adjust our expectations
# accordingly. Sometimes, we need to use entirely different commands.
#
# Note that this check is intentionally implemented somewhat differently to
# the similar-looking environment check in JAVA_HOME.mk. That check is
# concerned with how the environment will represent paths, and needs to be
# fairly fine-grained; in this case, we just need to know whether we're
# going to end up with a built-in from cmd.exe or not.
ifdef ComSpec
gradlew-build = gradlew.bat build
# MKDIR neither understands nor requires the “-p” flag, but is one of the few
# Windows CLI utilities which relies on Windows path separators (“\”).
mkdir = mkdir $(subst /,\,$(1))
# So is RMDIR. Note that even though RMDIR /S does remove files under a
# directory, it still can't be called interchangeably on a file or directory
# (unlike `rm -R`).
rmdir_r = -rmdir /s /q $(subst /,\,$(1))
else
gradlew-build = ./gradlew build
mkdir = mkdir -p $(1)
# Named rmdir_r – not rm_r – to indicate that it should only be used to operate
# on directories due to limitations of the Windows variant of the command.
rmdir_r = rm -Rf $(1)
endif
