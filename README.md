# ![Pinry](https://raw.github.com/pinry/pinry/master/docs/src/imgs/logo-dark.png)

The open-source core of Pinry, a tiling image board system for people
who want to save, tag, and share images, videos and webpages in an easy
to skim through format.

For more information ( screenshots and document ) visit [https://pinry.github.io/pinry/](https://pinry.github.io/pinry/).

## About this fork

This fork is functionally equivalent to the original Pinry, but all backend and frontend dependencies were updated due to numerous knwon security issues in them. References to the docker image is removed because it installs the original version with the outdated, unsafe depencencies.

## Features
- Image fetch and online preview
- Tagging system for Pins
- Browser Extensions
- Multi-user support
- Works well with docker
- Both public and private boards (add @2020.02.11)
- Search by tags / Search boards with name (add @2020.02.14)
- Full API support via DRF (add @2022.02.19)
- CLI support (Add image or url to Pinry via [command-line tool](https://github.com/pinry/pinry-cli-py)) (add @2022.02.20)
- i18n support (if you want to help to translate, please contact us in issues) (add @2020.04.23)
  - [x] English
  - [x] 简体中文
  - [x] French Support by [Lilian](https://github.com/LilianBoulard)
  
## Preview
![image](https://user-images.githubusercontent.com/4109722/166976413-38b575f2-a246-4852-ba05-11bca5f9b052.png)


## Requirements

See our full documentation at [https://pinry.github.io/pinry/development/](https://pinry.github.io/pinry/development/)


## Development

See our full documentation at [https://pinry.github.io/pinry/development/](https://pinry.github.io/pinry/development/)

## Contributors

The core contributors for Pinry have been are:

* Isaac Bythewood <http://isaacbythewood.com/>
* Krzysztof Klimonda <https://github.com/kklimonda>
* Lapo Luchini <https://github.com/lapo-luchini>
* Ji Qu <https://winkidney.com/>

This fork is maintained by:
* mimrock <https://github.com/mimrock>

For a full list of contributors check out the [GitHub Contributors Graph](https://github.com/pinry/pinry/graphs/contributors)
