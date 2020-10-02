[![Community Project header](https://github.com/newrelic/opensource-website/raw/master/src/images/categories/Community_Project.png)](https://opensource.newrelic.com/oss-category/#community-project)

# [Name of Project] [build badges go here when available]

>[Brief description - what is the project and value does it provide? How often should users expect to get releases? How is versioning set up? Where does this project want to go?]

## Installation

> [Include a step-by-step procedure on how to get your code installed. Be sure to include any third-party dependencies that need to be installed separately]

## Getting Started
>[Simple steps to start working with the software similar to a "Hello World"]

## Usage

This project includes all the packages of prometheus exporters in order to the installation easier.
In order to add a new exporter add a new folder in the path `exporters/{exportername}`.

In each folder we expect to find a `LICENSE` file a `exporter.yml` having the definition of the exporter, a `Makefile` with the command `all` building the exporter and a powershell script `win_build.ps1` building the exporter.

Refers to `githubactions` exporter example in order to doublecheck parameters and fields of such scripts

The definition file will have the following fields:
``` yaml
# name of the exporter, should mach with the folder name
name: githubactions
# version of the package created
version: 1.2.2
# URL to the git project hosting the exporter
exporter_repo_url: https://github.com/Spendesk/github-actions-exporter
# Tag of the exporter to checkout
exporter_tag: v1.2
# Commit of the exporter to checkout (used if tag property is empty)
exporter_commit: ifTagIsSetThisIsNotUsed
# Changelog to add to the new release
exporter_changelog: "Changelog for the current version, nothing relly changed, just testing pipeline"
# Enable packages for Linux
package_linux: true
# Enable packages for Windows
package_windows: true
# Exporter GUID used in the msi package
exporter_guid: 7B629E90-530F-4FAA-B7FE-1F1B30A95714
# Lincense GUID used in the msi package
license_guid: 95E897AC-895A-43BE-A5EF-D72AD58E4ED1
```

On merge to master a github action workflow will start. 

 - In case one exporter definition has been modified or added the exporter will be released for the os requested and a Github release will be created
 - In case two exporters definition have been modified the pipeline fail
 - In case no exporters definition have been modified the pipeline terminates

Please notice that exporters have their own `build` script but share the packaging scripts, located under `./scripts`

## Testing

>[**Optional** - Include instructions on how to run tests if we include tests with the codebase. Remove this section if it's not needed.]

## Support

New Relic hosts and moderates an online forum where customers can interact with New Relic employees as well as other customers to get help and share best practices. Like all official New Relic open source projects, there's a related Community topic in the New Relic Explorers Hub. You can find this project's topic/threads here:

>Add the url for the support thread here

## Contributing
We encourage your contributions to improve [project name]! Keep in mind when you submit your pull request, you'll need to sign the CLA via the click-through using CLA-Assistant. You only have to sign the CLA one time per project.
If you have any questions, or to execute our corporate CLA, required if your contribution is on behalf of a company,  please drop us an email at opensource@newrelic.com.

## License
[Project Name] is licensed under the [Apache 2.0](http://apache.org/licenses/LICENSE-2.0.txt) License.
>[If applicable: The [project name] also uses source code from third-party libraries. You can find full details on which libraries are used and the terms under which they are licensed in the third-party notices document.]
