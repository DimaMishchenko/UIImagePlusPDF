/*
MIT License

Copyright (c) 2018 DimaMishchenko

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
*/

import UIKit
import Foundation

// MARK: - UIImage+PDF

public extension UIImage {
    
    static func pdfImage(with name: String, width: CGFloat, pageNumber: Int = 1) -> UIImage? {
        
        guard let url = resourceURLForName(name) else { return nil }
        return _pdfImage(with: url, size: CGSize(width: width, height: 0), pageNumber: pageNumber)
    }
    
    static func pdfImage(with name: String, height: CGFloat, pageNumber: Int = 1) -> UIImage? {
        
        guard let url = resourceURLForName(name) else { return nil }
        return _pdfImage(with: url, size: CGSize(width: 0, height: height), pageNumber: pageNumber)
    }
    
    static func pdfImage(with name: String, pageNumber: Int = 1) -> UIImage? {
        
        guard let url = resourceURLForName(name) else { return nil }
        return _pdfImage(with: url, size: CGSize(width: 0, height: 0), pageNumber: pageNumber)
    }
    
    static func pdfImage(with name: String, size: CGSize, pageNumber: Int = 1) -> UIImage? {
        
        guard let url = resourceURLForName(name) else { return nil }
        return _pdfImage(with: url, size: size, pageNumber: pageNumber)
    }
    
    static func pdfImage(with url: URL, width: CGFloat, pageNumber: Int = 1) -> UIImage? {
        
        return _pdfImage(with: url, size: CGSize(width: width, height: 0), pageNumber: pageNumber)
    }
    
    static func pdfImage(with url: URL, height: CGFloat, pageNumber: Int = 1) -> UIImage? {
        
        return _pdfImage(with: url, size: CGSize(width: 0, height: height), pageNumber: pageNumber)
    }
    
    static func pdfImage(with url: URL, pageNumber: Int = 1) -> UIImage? {
        
        return _pdfImage(with: url, size: CGSize(width: 0, height: 0), pageNumber: pageNumber)
    }
    
    static func pdfImage(with url: URL, size: CGSize, pageNumber: Int = 1) -> UIImage? {
        
        return _pdfImage(with:url, size: size, pageNumber: pageNumber)
    }
}

// MARK: - Private

extension UIImage {
    
    private static func _pdfImage(with url: URL, size: CGSize, pageNumber: Int) -> UIImage? {
        
        guard
            let pdf = CGPDFDocument(url as CFURL),
            let page = pdf.page(at: pageNumber)
        else { return nil }
        
        
        let size = pdfSize(
            withOrginalSize: page.getBoxRect(.mediaBox).size,
            selectedSize: size
        )
        
        if
            pdfCacheInMemory,
            let image = memoryCachedImage(url: url, size: size, pageNumber: pageNumber) {
             
            return image
        }
        
        guard
            let imageUrl = pdfCacheOnDisk ? pdfCacheURL(with: url, size: size, pageNumber: pageNumber) : url
        else { return nil }
        
        if
            pdfCacheOnDisk,
            FileManager.default.fileExists(atPath: imageUrl.path),
            let image = UIImage(contentsOfFile: imageUrl.path),
            let cgImage = image.cgImage {
            
            return UIImage(cgImage: cgImage, scale: UIScreen.main.scale, orientation: .up)
        }
        
        UIGraphicsBeginImageContextWithOptions(size, false, UIScreen.main.scale)
        
        guard let context = UIGraphicsGetCurrentContext() else { return nil }
            
        context.concatenate(CGAffineTransform(a: 1, b: 0, c: 0, d: -1, tx: 0, ty: size.height))
        let rect = page.getBoxRect(.mediaBox)
        context.translateBy(x: -rect.origin.x, y: -rect.origin.y)
        context.scaleBy(x: size.width / rect.size.width, y: size.height / rect.size.height)
        context.drawPDFPage(page)
        let imageFromContext = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        guard
            let image = imageFromContext,
            let imageData = image.pngData(),
            let cgImage = image.cgImage
        else { return nil }

        if pdfCacheOnDisk      { cacheOnDisk(data: imageData, url: imageUrl) }
        if pdfCacheInMemory    { cacheImageInMemory(image, url: url, size: size, pageNumber: pageNumber) }

        return UIImage(cgImage: cgImage, scale: UIScreen.main.scale, orientation: .up)
    }
    
    private static func resourceURLForName(_ resourceName: String) -> URL? {
        
        let isSuffix = resourceName.lowercased().hasSuffix(".pdf")
        let name = isSuffix ? resourceName : resourceName + ".pdf"
        
        if let path = Bundle.main.path(forResource: name, ofType: nil) {
            return URL(fileURLWithPath: path)
        }
        return nil
    }
    
    private static func pdfSize(with url: URL, size: CGSize, pageNumber: Int) -> CGSize? {
    
        guard
            let pdf = CGPDFDocument(url as CFURL),
            let page = pdf.page(at: pageNumber)
        else { return nil }
        
        return pdfSize(
            withOrginalSize: page.getBoxRect(.mediaBox).size,
            selectedSize: size
        )
    }
    
    private static func pdfSize(withOrginalSize orginalSize: CGSize, selectedSize: CGSize) -> CGSize {
        
        guard selectedSize != .zero else { return orginalSize }
        guard selectedSize.width == 0 || selectedSize.height == 0 else { return selectedSize }
        
        let multiplier = (
            selectedSize.width == 0 ? selectedSize.height / orginalSize.height : selectedSize.width / orginalSize.width
        )
        
        return CGSize(
            width: ceil(orginalSize.width * multiplier),
            height: ceil(orginalSize.height * multiplier)
        )
    }
}

// MARK: - Cache Public

public extension UIImage {
    
    static var pdfCacheOnDisk = false
    static var pdfCacheInMemory = true
    
    //all
    
    static func removeAllPDFCache() {
        
        removeAllPDFDiskCache()
        removeAllPDFMemoryCache()
    }
    
    static func removeAllPDFMemoryCache() {
        
        imageCache.removeAllObjects()
    }
    
    static func removeAllPDFDiskCache() {
        
        let cacheDirectory = NSSearchPathForDirectoriesInDomains(
            .cachesDirectory,
            .userDomainMask,
            true
        )[0] + "/" + kDiskCacheFolderName
        
        try? FileManager.default.removeItem(atPath: cacheDirectory)
    }
    
    //memory
    
    static func removeMemoryCachedPDFImage(with name: String, size: CGSize, pageNumber: Int = 1) {
        
        guard let url = resourceURLForName(name) else { return }
        removeMemoryCachedPDFImage(with: url, size: size, pageNumber: pageNumber)
    }
    
    static func removeMemoryCachedPDFImage(with url: URL, size: CGSize, pageNumber: Int = 1) {
        
        guard
            let size = pdfSize(with: url, size: size, pageNumber: pageNumber),
            let hash = pdfCacheHashString(with: url, size: size, pageNumber: pageNumber)
        else { return }
        
        imageCache.removeObject(forKey: NSString(string: String(hash)))
    }
    
    //disk
    
    static func removeDiskCachedPDFImage(with name: String, size: CGSize, pageNumber: Int = 1) {
        
        guard let url = resourceURLForName(name) else { return }
        removeDiskCachedPDFImage(with: url, size: size, pageNumber: pageNumber)
    }
    
    static func removeDiskCachedPDFImage(with url: URL, size: CGSize, pageNumber: Int = 1) {
        
        guard
            let size = pdfSize(with: url, size: size, pageNumber: pageNumber),
            let imageUrl = pdfCacheURL(with: url, size: size, pageNumber: pageNumber)
        else { return }
        
        try? FileManager.default.removeItem(at: imageUrl)
    }
}

// MARK: - Cache Private

extension UIImage {
    
    // MARK: - Memory Cache
    
    private static let imageCache = NSCache<NSString, UIImage>()
    
    private static func cacheImageInMemory(_ image: UIImage, url: URL, size: CGSize, pageNumber: Int) {
        
        guard let hash = pdfCacheHashString(with: url, size: size, pageNumber: pageNumber) else { return }
        imageCache.setObject(image, forKey: NSString(string: String(hash)))
    }
    
    private static func memoryCachedImage(url: URL, size: CGSize, pageNumber: Int) -> UIImage? {
        
        guard let hash = pdfCacheHashString(with: url, size: size, pageNumber: pageNumber) else { return nil }
        return imageCache.object(forKey: NSString(string: String(hash)))
    }
    
    // MARK: - Disk Cache
    
    private static let kDiskCacheFolderName = "PDFCache"
    
    private static func cacheOnDisk(data: Data, url: URL) {
        
        try? data.write(to: url, options: [])
    }
    
    private static func pdfCacheURL(with url: URL, size: CGSize, pageNumber: Int) -> URL? {
        
        do {
            guard let hash = pdfCacheHashString(with: url, size: size, pageNumber: pageNumber) else { return nil }
            
            let cacheDirectory = NSSearchPathForDirectoriesInDomains(
                .cachesDirectory,
                .userDomainMask,
                true
            )[0] + "/" + kDiskCacheFolderName
            
            try FileManager.default.createDirectory(
                atPath: cacheDirectory,
                withIntermediateDirectories: true,
                attributes: nil
            )
        
            return URL(fileURLWithPath: cacheDirectory + "/" + String(format:"%2X", hash) + ".png")
        
        } catch { return nil }
    }
    
    private static func pdfCacheHashString(with url: URL, size: CGSize, pageNumber: Int) -> Int? {
        
        guard
            let attributes = try? FileManager.default.attributesOfItem(atPath: url.path),
            let fileSize = attributes[.size] as? NSNumber,
            let fileDate = attributes[.modificationDate] as? Date
        else { return nil }
        
        let hashables =
            url.path +
            fileSize.stringValue +
            String(fileDate.timeIntervalSince1970) +
            String(describing: size) +
            String(describing: pageNumber)
        
        return hashables.hash
    }
}
