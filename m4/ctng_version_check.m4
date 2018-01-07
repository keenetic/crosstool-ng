# Check if a given program is available with a particular version.
#   CTNG_PROG_VERSION(VAR, HELP, PROG, SRCH, VERSION_CHECK[, CONFIG_OPT])
# Search for PROG under possible names of SRCH. Allow user overrides in variable
# VAR; display HELP message. Try to find a version that satisfies VERSION_CHECK
# regexp; if that is achieved, set CONFIG_OPT in the kconfig. Otherwise, settle
# for any version found.
# Sets acx_version_VAR_ok to ':' if the version met the criterion, or false otherwise.
AC_DEFUN([CTNG_PROG_VERSION],
    [AS_IF([test -z "$EGREP"],
         [AC_MSG_ERROR([This macro can only be used after checking for EGREP])])
     CTNG_WITH_DEPRECATED([$3], [$1])
     AC_ARG_VAR([$1], [Specify the full path to $2])
     acx_version_$1_ok=false
     AC_CACHE_CHECK([for $3], [ac_cv_path_$1],
         [AC_PATH_PROGS_FEATURE_CHECK([$1], [$4],
              [[ver=$($ac_path_$1 --version 2>/dev/null| $EGREP $5)
                test -z "$ac_cv_path_$1" && ac_cv_path_$1=$ac_path_$1
                test -n "$ver" && ac_cv_path_$1="$ac_path_$1" ac_path_$1_found=: acx_version_$1_ok=:]])])
     AS_IF([test -n "$1"],
         [[ver=$($ac_path_$1 --version 2>/dev/null| $EGREP $5)
           test -n "$ver" && acx_version_$1_ok=:]])
     AC_MSG_CHECKING([for $2])
     AS_IF([$acx_version_$1_ok],
         [AC_MSG_RESULT([yes])],
         [AC_MSG_RESULT([no])])
     AC_SUBST([$1], [$ac_cv_path_$1])
     AS_IF([test -n "$6"],
         [AS_IF([$acx_version_$1_ok], [$6=y], [$6=])
          CTNG_SET_KCONFIG_OPTION([$6])])
    ])

# Same as above, but make it a fatal error if the tool is not found at all
# (i.e. "require any version, prefer version X or newer")
AC_DEFUN([CTNG_PROG_VERSION_REQ_ANY],
    [CTNG_PROG_VERSION([$1], [$2], [$3], [$4], [$5], [$6])
     AS_IF([test -z "$$1"],
         [AC_MSG_ERROR([Required tool not found: $3])])
    ])

# Same, but also require the version check to pass
# (i.e. "require version X or newer")
AC_DEFUN([CTNG_PROG_VERSION_REQ_STRICT],
    [CTNG_PROG_VERSION([$1], [$2], [$3], [$4], [$5], [$6])
     AS_IF([test -z "$$1" || ! $acx_version_$1_ok],
         [AC_MSG_ERROR([Required tool not found: $2])])
    ])

