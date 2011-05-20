# ChiliPDF Plugin - Flexible PDF exporting for ChiliProject/Redmine

## Experimental repository!!

I am in the middle of getting this to a stable state. The installation
process is not standard, nore is it properly documented. Additionally,
it still requires manual patches to the base Redmine/ChiliProject application
in order to function.

In short, you likely **do not want to install it at this point...**


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

## FEATURES:

1. Provides PDF export of any project wiki page to PDF with a baseline
  stylesheet. The styling can be customized by modifying the "pdf.css'
  asset file that ships with the library.

## SCREENSHOTS:

...

## PROBLEMS:

1. Requires a patch to the Redmine/ChiliProject core application in order to
   prevent a 'Double render' error on the WikiController. A pull request
   [has been submitted](https://github.com/chiliproject/chiliproject/pull/62)
   to the ChiliProject core team. Until then, you can manually apply the (small)
   patch to your app if you like. The changeset can be found
   [here](https://github.com/tomkersten/chiliproject/commit/b4e345dca9d72d8af9e8326c7cd8642e550be379).
1. No other PDF exports have been implemented yet using this library, so there will
   be two PDF libraries in your application if you add this plugin. This won't cause
   any problems, but...just know that any other PDF exports you do are not a result
   of this gem. Issues, roadmaps, and Gantt charts will likely be coming if the
   wiki exports show promise.

## SYNOPSIS:

...

## REQUIREMENTS:

* wicked_pdf

## INSTALL:

```
...no published gem yet
```


## UNINSTALL:

...

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

## Contributors (sorted alphabetically)

