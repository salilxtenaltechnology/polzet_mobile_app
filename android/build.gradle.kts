allprojects {
    repositories {
        google()
        mavenCentral()
    }
}

// Set the root project build directory
rootProject.layout.buildDirectory.set(file("../build"))

subprojects {
    // Set each subproject's build directory under the root build directory
    project.layout.buildDirectory.set(file("${rootProject.layout.buildDirectory.get()}/${project.name}"))
    
    // Make all subprojects depend on the :app module evaluation
    project.evaluationDependsOn(":app")
}

tasks.register<Delete>("clean") {
    delete(rootProject.layout.buildDirectory)
}