# UIImagePlusPDF
[![Swift 4](https://img.shields.io/badge/Swift-4-orange.svg?style=flat)](https://developer.apple.com/swift/)
[![CocoaPods compatible](https://img.shields.io/cocoapods/v/UIImagePlusPDF.svg)](https://cocoapods.org/pods/UIImagePlusPDF)
[![Packagist](https://img.shields.io/packagist/l/doctrine/orm.svg)]()

UIImage extensions to use PDF files.

## Installation

[CocoaPods](http://www.cocoapods.org):

``` ruby
pod 'UIImagePlusPDF'
```

## Usage
**Simple example:**
``` swift
let imageView = UIImageView()
let image = UIImage.pdfImage(with: "imageName")
imageView.image = image
```
**Other options**
``` swift
//with custom width 
UIImage.pdfImage(with: "imageName", width: 350)

//with custom height
UIImage.pdfImage(with: "imageName", height: 350)

//with custom size
UIImage.pdfImage(with: "imageName", size: CGSize(width: 300, height:  400))

//with page number
UIImage.pdfImage(with: "multipage pdf file", width: 300, pageNumber: 2)

//same options with resource url
UIImage.pdfImage(with: URL(string: "path"))
```

## Cache
**Memory cache:**
``` swift
//using NSCache
//default is true
UIImage.pdfCacheInMemory = true
```
**Disk cache:**
``` swift
//default is false
UIImage.pdfCacheOnDisk = true
```
**Cache deleting:**
``` swift
//all cache
UIImage.removeAllPDFCache()

//all memory cache
UIImage.removeAllPDFMemoryCache()

//all disk cache
UIImage.removeAllPDFDiskCache()

//memory cached pdf with name
UIImage.removeMemoryCachedPDFImage(
    with: "pdf name", 
    size: CGSize(width: usedWidth, height: usedHeight), 
    pageNumber: 1 /*optional, default is 1*/
)

//memory cached pdf with url
UIImage.removeMemoryCachedPDFImage(
    with: URL(string: "path"), 
    size: CGSize(width: usedWidth, height: usedHeight), 
    pageNumber: 1 /*optional, default is 1*/
)

//disk cached pdf with name
UIImage.removeDiskCachedPDFImage(
    with: "pdf name", 
    size: CGSize(width: usedWidth, height: usedHeight), 
    pageNumber: 1 /*optional, default is 1*/
)

//disk cached pdf with url
UIImage.removeDiskCachedPDFImage(
    with: URL(string: "path"), 
    size: CGSize(width: usedWidth, height: usedHeight), 
    pageNumber: 1 /*optional, default is 1*/
)
```
## License
**UIImagePlusPDF** is under MIT license. See the [LICENSE](LICENSE) file for more info.
