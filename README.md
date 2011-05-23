# ChiliPDF Plugin - Flexible PDF exporting for ChiliProject/Redmine

* http://github.com/tomkersten/chili_pdf

## DESCRIPTION:

ChiliProject (/Redmine) plugin which implements/enhances PDF-export functionality using the Webkit rendering engine (via the 'wkhtmltopdf' executable).

## NOTABLE ITEMS TO CONSIDER

1. This plugin is distributed as a gem, but does ship with asset files
   (stylesheets, etc). Therefore, the installation procedure is not
   the standard process.
1. There is a dependency on having the wkhtmltopdf binary installed.on your
   server. Technically this is a dependency of the library being used to
   generate the PDFs ([wicked_pdf](https://github.com/mileszs/wicked_pdf)),
   but, it's something you should be aware of.
1. Requires a patch to the Redmine/ChiliProject core application in order to
   prevent a 'Double render' error on the WikiController. A pull request
   [has been submitted](https://github.com/chiliproject/chiliproject/pull/62)
   to the ChiliProject core team. Until then, you can manually apply the (small)
   patch to your app if you like. The changeset can be found
   [here](https://github.com/tomkersten/chiliproject/commit/b4e345dca9d72d8af9e8326c7cd8642e550be379).

## FEATURES:

1. Provides PDF export of any project wiki page to PDF with a baseline
  stylesheet. The styling can be customized by modifying the "pdf.css'
  asset file that ships with the library.

## SCREENSHOTS:

You can find a few screenshots [here](http://www.flickr.com/photos/tomkersten/sets/72157626768112790/).

## PROBLEMS:

1. No other PDF exports have been implemented yet using this library, so there will
   be two PDF libraries in your application if you add this plugin. This won't cause
   any problems, but...just know that any other PDF exports you do are not a result
   of this gem. Issues, roadmaps, and Gantt charts will likely be coming if the
   wiki exports show promise.

## SYNOPSIS:

1. Install **version 0.9.9** of the [wkhtmltopdf](http://wkhtmltopdf.googlecode.com/) executable on the machine
   hosting ChiliProject. You can find binaries for Mac, Windows, and Linux [here](http://code.google.com/p/wkhtmltopdf/downloads/list).
1. Install the chili\_pdf gem
1. Cycle your application servers (Mongrel, unicorn, Passenger, etc)
1. Visit any wiki page and manually add a '.pdf' extension to the URL
   1. **NOTE:** You must be on an individual wiki page. Manually adding
      the '.pdf' on the 'default wiki page' URL (/projects/:project_id/wiki)
      will not work correctly at this time. The manual step will be removed
      in a future release.

## REQUIREMENTS:

* wicked\_pdf

## INSTALL:

```
gem install chili_pdf
```

### Manual steps after gem installation

In your 'config/environment.rb', add:

``` ruby
config.gem 'chili_pdf'
```

In your 'Rakefile', add:

``` ruby
require 'tasks/chili_pdf_tasks'
```

Run the installation rake task (installs assets)

```
RAILS_ENV=production rake chili_pdf:install
```

Cycle your application server (mongrel, unicorn, etc)

## UNINSTALL:

Run the uninstall rake task (reverts migrations & uninstalls assets)

```
RAILS_ENV=production rake chili_pdf:uninstall
```

In your 'Rakefile', remove:

``` ruby
require 'chili_pdf'
```

In your 'config/environment.rb', remove:

``` ruby
config.gem 'chili_pdf'
```

Cycle your application server (mongrel, unicorn, whatevs)...

Then, uninstall the chili_pdf gem:

```
gem uninstall chili_pdf
```

Done.

## CONTRIBUTING AND/OR SUPPORT:

### Found a bug? Have a feature request?

Please file a ticket on the '[Issues](https://github.com/tomkersten/chili_pdf/issues)'
page of the Github project site

You can also drop me a message on Twitter [@tomkersten](http://twitter.com/tomkersten).

### Want to contribute?

(Better instructions coming soon)

1. Fork the project
1. Create a feature branch and implement your idea (preferably with
   tests)
1. Update the History.txt file in the 'Next Release' section (at the top)
1. Send a pull request

## LICENSE:

Refer to the [LICENSE](https://github.com/tomkersten/chili_pdf/blob/master/LICENSE) file
