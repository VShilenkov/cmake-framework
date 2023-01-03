set(UseJavaTargets "")

set(UseJavaCommands __java_copy_file
                    __java_copy_resource_namespaces
                    __java_export_jar
                    __java_lcat
                    add_jar
                    create_javadoc
                    create_javah
                    export_jars
                    find_jar
                    install_jar
                    install_jar_exports
                    install_jni_symlink
)

set(UseJavaMacros "")

set(UseJavaVariables _JAVA_EXPORT_TARGETS_SCRIPT
                     _JAVA_SYMLINK_SCRIPT
                     _UseJava_PATH_SEP
)