# UIImagePlusPDF
[![Swift 4](https://img.shields.io/badge/Swift-4-orange.svg?style=flat)](https://developer.apple.com/swift/) [![Packagist](https://img.shields.io/packagist/l/doctrine/orm.svg)]()
UIImage extensions to use PDF files.

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
static func removeAllPDFCache()
static func removeAllPDFMemoryCache()
static func removeAllPDFDiskCache()
static func removeMemoryCachedPDFImage(with name: String, size: CGSize, pageNumber: Int = 1)
static func removeMemoryCachedPDFImage(with url: URL, size: CGSize, pageNumber: Int = 1)
static func removeDiskCachedPDFImage(with name: String, size: CGSize, pageNumber: Int = 1)
static func removeDiskCachedPDFImage(with url: URL, size: CGSize, pageNumber: Int = 1)
```
## License
**UIImagePlusPDF** is under MIT license. See the [LICENSE](LICENSE) file for more info.
