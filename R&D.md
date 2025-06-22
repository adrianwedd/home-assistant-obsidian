# **Research and Development Plan: A Home Assistant Addon for linuxserver/obsidian**

## **Introduction: Architecting a Professional Home Assistant Addon**

This document presents a comprehensive research and development plan for the creation of a secure, stable, and seamlessly integrated Home Assistant addon for Obsidian. The primary objective is to wrap the official linuxserver/obsidian Docker image, making the powerful note-taking application a first-class citizen within the Home Assistant ecosystem. This plan moves beyond a simple proof-of-concept to architect a professional-grade addon suitable for widespread community use.

The development process will be guided by a set of core architectural principles designed to maximize stability, usability, and long-term maintainability. These pillars ensure that the final product is not only functional but also robust, secure, and easy for both end-users and the developer to manage.

### **Architectural Pillars**

* **The "Pure Wrapper" Philosophy:** The foundational strategy of this project is to avoid reinventing the wheel. Instead of attempting to build and maintain a complex Docker image containing Obsidian and its dependencies from scratch, this addon will function as a "pure wrapper." It will leverage the image key within the addon's configuration file to instruct the Home Assistant Supervisor to pull and run the official, pre-built linuxserver/obsidian image directly.\[1\] This approach confers several significant advantages: it drastically simplifies the development and build process, offloads the complex maintenance of the core application to the expert LinuxServer.io team, and guarantees that users of the addon will benefit from the same regular and timely application updates provided to the broader Docker community.\[3\]  
* **Ingress-First User Experience:** For a graphical user interface (GUI) application like Obsidian, which is delivered via the KasmVNC web interface in the linuxserver/obsidian image, a seamless user experience is paramount. Therefore, Home Assistant's Ingress feature will be treated as a core, non-negotiable requirement. Ingress allows the addon's web UI to be embedded directly within the Home Assistant interface, inheriting its authentication and secure remote access capabilities.\[4\] This eliminates the need for users to manually configure port forwarding, manage separate logins, or expose additional services to the internet, resulting in a more professional, secure, and user-friendly product.\[6\]  
* **Configuration as Code:** All user-configurable parameters will be managed declaratively through the addon's config.yaml file. This file will feature a robust and clearly defined schema, which enables Home Assistant to automatically generate a user-friendly configuration panel in the UI.\[1\] This approach provides users with input validation, clear descriptions for each option, and a consistent configuration experience, while ensuring the addon receives predictable and correctly formatted data.\[1\]  
* **Automation-Driven Quality:** A commitment to modern software development practices is essential for a high-quality product. This plan incorporates a fully automated Continuous Integration and Continuous Deployment (CI/CD) pipeline using GitHub Actions. This pipeline will be responsible for automatically linting code against best practices, running validation checks, and managing the release process. This automation ensures high-quality, repeatable builds and significantly reduces the potential for human error.

## **Phase 1: Foundational Analysis and Environment Setup**

Before any code is written, a thorough analysis of the project's components is required. This phase is dedicated to deconstructing the target Docker image to understand its operational needs and establishing a professional, repeatable development workflow that will serve as the foundation for the entire project.

### **1.1. Deconstruction of the linuxserver/obsidian Docker Image**

The first step is to fully understand the behavior and requirements of the linuxserver/obsidian Docker image. This analysis will directly inform the entire addon configuration, ensuring that all necessary parameters are correctly exposed and managed.

The linuxserver/obsidian container is based on the Docker Baseimage KasmVNC.\[7\] This is a critical piece of information, as it reveals that the image provides a full Linux desktop environment, including the Obsidian application, which is then streamed to the user's web browser. This KasmVNC foundation is what makes the Ingress-first approach the ideal method for integration.

A detailed review of the official Docker Hub page and the LinuxServer.io documentation reveals several core operational parameters that the addon must accommodate.

* **Core Parameters:**  
  * **User and Group Mapping:** The environment variables PUID (Process User ID) and PGID (Process Group ID) are standard across LinuxServer.io images. They are used to set the user and group that the application runs as inside the container. This is essential for ensuring correct file ownership and permissions on the persistent data volume.\[7\]  
  * **Timezone:** The TZ environment variable allows the user to specify their timezone (e.g., America/New\_York), ensuring that timestamps and other time-sensitive operations within the application are accurate.\[7\]  
  * **Networking:** The image exposes 3000/tcp for the standard HTTP-based KasmVNC web GUI. For the purposes of this addon, only the HTTP port is relevant, as Ingress will handle the secure connection.  
  * **Persistent Storage:** The image designates the /config directory inside the container as its volume for persistent data. This path is used to store all application settings, user preferences, and, most importantly, the user's Obsidian vaults.  
* **Advanced Parameters and Special Flags:**  
  * **Shared Memory:** The documentation explicitly notes that the \--shm-size flag is necessary for Electron-based applications like Obsidian to function correctly. This flag increases the size of the shared memory (/dev/shm) available to the container.  
  * **Security Context:** For some modern GUI applications, the \--security-opt seccomp=unconfined flag may be required. If the image requires forbidden system calls, the addon must request elevated permissions via full\_access: true or a specific entry in the privileged list.\[5\] This reduces container isolation and must be clearly documented.

The following table summarizes this analysis, translating the raw Docker parameters into actionable requirements that will guide the addon's implementation.

| Parameter Type | Name | Description & Source | Addon Implementation Notes |
| :---- | :---- | :---- | :---- |
| Environment | PUID / PGID | User/Group ID for file permissions on persistent storage.\[7\] | Expose as puid and pgid integer options in config.yaml. |
| Environment | TZ | Timezone string (e.g., Europe/London) to set the container's time.\[7\] | Expose as a tz string option in config.yaml. |
| Port | 3000/tcp | The internal port for the KasmVNC Web UI (HTTP). | This port will be the target for Ingress. It should not be exposed directly on the host. |
| Volume | /config | The internal path for persistent storage of all settings and user vaults. | This path must be mapped to the addon's persistent storage directory (/data). |
| Runtime Flag | \--shm-size | Specifies a larger shared memory size, required for Electron apps. | Handled by the Supervisor. The modern tmpfs: true option in config.yaml can be used.\[5\] |
| Runtime Flag | \--security-opt | seccomp=unconfined, sometimes needed for GUI apps. | Requires full\_access: true or privileged list in config.yaml. Carries security risks.\[5\] |

### **1.2. Structuring the Addon Repository**

A clean, standardized, and maintainable project structure is a hallmark of professional software development. This project will adhere to the community-standard structure defined by the official home-assistant/addons-example repository.\[8\]

The repository will be organized as follows:

* **obsidian/ (The Addon Directory):**  
  * config.yaml: The addon manifest.  
  * run.sh: The execution script.  
  * icon.png & logo.png: Branding assets (128x128px and \~250x100px respectively).\[6\]  
  * DOCS.md: Essential documentation, which should clearly explain the backup strategy, including the specific paths (BrowserCache/, .cache/) excluded from snapshots.  
  * translations/en.yaml: A stub file for UI translations, a requirement for submission to community repositories.\[5\]  
* **repository.yaml:** The repository manifest.  
* **.github/:** Directory for CI/CD automation workflows.

The translations/en.yaml stub should contain at least the basic configuration keys to pass linting:

\# /obsidian/translations/en.yaml  
configuration:  
  puid:  
    name: "User ID (PUID)"  
    description: "The user ID for file permissions. See addon documentation for details."  
  pgid:  
    name: "Group ID (PGID)"  
    description: "The group ID for file permissions. See addon documentation for details."  
  tz:  
    name: "Timezone"  
    description: "Your local timezone (e.g., 'America/New\_York')."

Notably, a Dockerfile is absent. Because this project follows the "pure wrapper" philosophy, the Supervisor will not build a local image.

### **1.3. Configuring the Development Environment**

This plan mandates the use of the official Visual Studio Code Devcontainer setup for Home Assistant addon development.\[10\] This provides an efficient and realistic testing environment. The Home Assistant instance will be accessible at http://localhost:8123, with the Obsidian addon ready for testing.\[10\]

## **Phase 2: Core Addon Implementation (config.yaml)**

This phase focuses on the meticulous construction of the addon's central manifest, config.yaml.

### **2.1. Essential Metadata**

The first step is to give the addon a clear and professional identity.\[5\]

* name: "Obsidian"  
* version: "1.0.0"  
* slug: "obsidian"  
* description: "A secure, self-hosted digital brain with Home Assistant integration."  
* url: A link to the addon's GitHub repository.  
* arch: \[aarch64, amd64, armv7\].  
* init: false: This crucial setting is mandatory. As the addon's run.sh will call the upstream exec /init, this prevents the s6 supervisor from running twice and ensures stability.\[5\]

### **2.2. The Wrapper Strategy: The image Key**

To implement the "pure wrapper" philosophy, the image key is used.\[5\]

The implementation will be: image: "lscr.io/linuxserver/obsidian:{version}".

* **Multi-Architecture Manifests:** The linuxserver/obsidian image uses multi-arch manifests, so the {arch} placeholder is not required in the image string.\[7\]  
* **Version and Tag Coupling:** The addon's version must exactly match the Docker image tag specified in the image key.\[5\]  
* **Automated Updates:** A tool like Renovate is recommended to monitor for new tags and open a pull request that bumps both the image tag and the corresponding version in config.yaml.

### **2.3. User Configuration: options and schema**

The options and schema keys expose validated options to the user.\[5\] For v1.0, the UI is kept minimal by only exposing essential options.

* **User/Group and Timezone:**  
  options:  
    puid: 1000  
    pgid: 1000  
    tz: ""  
  schema:  
    puid: int  
    pgid: int  
    tz: str

### **2.4. Seamless Integration and Resource Management**

This section defines the addon's integration with Home Assistant's core features.

* **Ingress:** Embeds the Obsidian web UI directly and securely into the Home Assistant frontend.\[6\]  
  ingress: true  
  ingress\_port: 3000  
  panel\_icon: mdi:brain  
  panel\_title: Obsidian  
  ports: {}

* **Health and Resource Management:** To improve stability, a healthcheck and resource hints are added.\[5\]  
  watchdog: "http://\[HOST\]:3000/"  
  memory: 512

* **Snapshot Friendliness:** To prevent large browser caches from bloating user backups, the backup\_exclude key is used.\[5\]  
  backup\_exclude:  
    \- 'BrowserCache/'  
    \- '.cache/'

### **2.5. Persistent Storage: map**

The config.yaml will contain map: \[data:rw\]. This makes the addon's managed persistent storage directory available at the /data path inside the container. The path mismatch with the upstream image's expectation of /config will be resolved in the run.sh script.

### **2.6. System Privileges and Security**

* **Shared Memory:** The requirement for an increased shared memory size is best handled with the modern tmpfs: true key in config.yaml.\[5\]

## **Phase 3: Execution Logic and Container Definition**

### **3.1. The run.sh Execution Script**

The run.sh script connects the user's configuration to the runtime environment of the container.\[1\]

1. **Shebang and Bashio:** The script must begin with \#\!/usr/bin/with-contenv bashio to make the bashio helper library available.\[12\]  
2. **Handle Path Mismatch:** This robust logic handles the creation of the symbolic link.  
   \# Symlink /data to /config to match linuxserver.io's expected data path.  
   \# This is more robust than a simple existence check, as it handles cases  
   \# where /config may have been created as a directory by the base image.  
   if \[ \! \-L /config \]; then  
     bashio::log.info "/config is not a symlink. Re-linking to /data..."  
     rm \-rf /config  
     ln \-s /data /config  
   fi

3. **Configuration Parsing:** The script will use bashio::config to read user options and export them as environment variables.  
4. **Execution Handoff:** The final and most critical line of the script is exec /init.

### **3.2. The Dockerfile Wrapper**

A Dockerfile is **not required and should be omitted** as the Supervisor ignores it when the image key is present.\[5\]

## **Phase 4: Quality Assurance, Automation, and Publishing**

### **4.1. Testing Protocols**

* **Local Testing (via Devcontainer):** The primary development loop will take place within the VS Code devcontainer at http://localhost:8123.\[10\]  
* **Remote Testing (on Real Hardware):** Before any official release, the addon must be tested on a physical device to catch architecture-specific bugs.\[10\]

### **4.2. Automation with GitHub Actions**

* **Linting Workflow:** A workflow using frenck/action-addon-linter will run on every push and pull\_request to validate addon files.  
* **Release Workflow:** A second workflow will automate creating official releases, triggered by a Git tag (e.g., v\*). An example step to update the version in config.yaml is shown below.  
  \# Example step from .github/workflows/release.yml  
  \- name: "Update version in config.yaml"  
    run: |  
      \# Install yq \- a portable YAML processor  
      sudo wget https://github.com/mikefarah/yq/releases/latest/download/yq\_linux\_amd64 \-O /usr/bin/yq && sudo chmod \+x /usr/bin/yq  
      \# Use yq with double quotes to allow shell expansion of the version  
      yq \-i ".version \= \\"${{ github.ref\_name | remove\_prefix: 'v' }}\\"" obsidian/config.yaml

### **4.3. Publishing the Addon**

* **The repository.yaml File:** This file must exist at the root of the GitHub repository.  
  name: "Obsidian Home Assistant Addon"  
  url: "https://github.com/your-username/your-repo-name"  
  maintainer: "Your Name \<your-email@example.com\>"

* **User Installation Instructions:** The project's main README.md file must include a clear, step-by-step guide for users to add the repository.

## **Conclusion and Future Development**

This plan outlines a professional methodology for creating a stable, secure, and maintainable Home Assistant addon for linuxserver/obsidian.

### **Future Development Backlog**

* **GPU Support (Backlog):** Investigate methods to allow users to optionally enable GPU hardware acceleration. This is not in scope for v1.0, as a user-configurable toggle requires a more complex implementation than is suitable for a pure-wrapper addon.  
* **Code Signing:** For enhanced security and to meet the requirements of official community repositories, pre-add the codenotary key to config.yaml (e.g., codenotary: "\[email protected\]").\[5\]  
* **Automated Release Notes:** Configure Renovate to include upstream changelog snippets in its pull requests for instant release notes.

#### **Works cited**

1. Publishing your add-on | Home Assistant Developer Docs, accessed on June 22, 2025, [https://developers.home-assistant.io/docs/add-ons/publishing/](https://developers.home-assistant.io/docs/add-ons/publishing/)  
2. addons/git\_pull/data/run.sh at master · home-assistant/addons \- GitHub, accessed on June 22, 2025, [https://github.com/home-assistant/hassio-addons/blob/master/git\_pull/data/run.sh](https://github.com/home-assistant/hassio-addons/blob/master/git_pull/data/run.sh)  
3. Your own Home Assistant add-on \- Dev notes, accessed on June 22, 2025, [https://blog.michal.pawlik.dev/posts/smarthome/home-assistant-addons/](https://blog.michal.pawlik.dev/posts/smarthome/home-assistant-addons/)  
4. Introducing Hass.io Ingress \- Home Assistant, accessed on June 22, 2025, [https://www.home-assistant.io/blog/2019/04/15/hassio-ingress/](https://www.home-assistant.io/blog/2019/04/15/hassio-ingress/)  
5. Add-on configuration | Home Assistant Developer Docs, accessed on June 22, 2025, [https://developers.home-assistant.io/docs/add-ons/configuration/](https://developers.home-assistant.io/docs/add-ons/configuration/)  
6. Presenting your addon | Home Assistant Developer Docs, accessed on June 22, 2025, [https://developers.home-assistant.io/docs/add-ons/presentation/](https://developers.home-assistant.io/docs/add-ons/presentation/)  
7. linuxserver/obsidian \- Docker Image, accessed on June 22, 2025, [https://hub.docker.com/r/linuxserver/obsidian](https://hub.docker.com/r/linuxserver/obsidian)  
8.   
   3. Home Assistant Addon — SunFounder Pironman documentation, accessed on June 22, 2025, [https://docs.sunfounder.com/projects/pironman-u1/en/latest/home\_assistant/ha\_addon.html](https://docs.sunfounder.com/projects/pironman-u1/en/latest/home_assistant/ha_addon.html)  
9. Add-on configuration | Home Assistant Developer Docs, accessed on June 22, 2025, [https://developers.home-assistant.io/docs/add-ons/configuration/](https://developers.home-assistant.io/docs/add-ons/configuration/)  
10. Developing an add-on | Home Assistant Developer Docs, accessed on June 22, 2025, [https://developers.home-assistant.io/docs/add-ons/development/](https://developers.home-assistant.io/docs/add-ons/development/)  
11. home-assistant-addon/music\_assistant\_beta/config.yaml at main \- GitHub, accessed on June 22, 2025, [https://github.com/music-assistant/home-assistant-addon/blob/main/music\_assistant\_beta/config.yaml](https://github.com/music-assistant/home-assistant-addon/blob/main/music_assistant_beta/config.yaml)  
12. Using hassio-cli | Home Assistant Developer Docs, accessed on June 22, 2025, [https://developers.home-assistant.io/docs/add-ons/cli/](https://developers.home-assistant.io/docs/add-ons/cli/)