import Foundation

open class FileSystemWatcher {
    open static var instance: FileSystemWatcher = FileSystemWatcher();

    var paneModels: [PaneModel] = []

    open var fsEventStream: FSEventStreamRef? = nil

    init() {
        var context: FSEventStreamContext = FSEventStreamContext()
        context.version = 0;
        context.retain = nil;
        context.release = nil;
        context.copyDescription = nil;
        context.info = UnsafeMutableRawPointer(Unmanaged.passUnretained(self).toOpaque())

        let paths = ["/"];
        let pathsToWatch = paths.map({ $0 as NSString }) as [AnyObject];

        let fileSystemObserverCallback: FSEventStreamCallback = {
            (stream: ConstFSEventStreamRef, contextInfo: UnsafeMutableRawPointer, numEvents: Int,
             eventPaths: UnsafeMutableRawPointer, eventFlags: UnsafePointer<FSEventStreamEventFlags>,
             eventIds: UnsafePointer<FSEventStreamEventId>) in
            let mySelf = Unmanaged<FileSystemWatcher>.fromOpaque(_ : UnsafeRawPointer(contextInfo)).takeUnretainedValue()
            let paths = unsafeBitCast(eventPaths, to: NSArray.self) as! [String]

            for paneModel in mySelf.paneModels {
                var modelPath = paneModel.getRoot().path + "/"

                modelPath = modelPath.substring(from: modelPath.characters.index(modelPath.startIndex, offsetBy: 1))
                if paths.contains(modelPath) {
                    paneModel.refreshCallback()
                }
            }
        } as! FSEventStreamCallback

        fsEventStream = FSEventStreamCreate(nil, fileSystemObserverCallback, &context, pathsToWatch as CFArray,
                FSEventStreamEventId(kFSEventStreamEventIdSinceNow), CFTimeInterval(1.0),
                FSEventStreamCreateFlags(kFSEventStreamCreateFlagUseCFTypes))

        FSEventStreamScheduleWithRunLoop(fsEventStream!, CFRunLoopGetCurrent(), CFRunLoopMode.defaultMode as! CFString)
        FSEventStreamStart(fsEventStream!)
    }

    func subscribeToFsEvents(_ paneModel: PaneModel) {
        if !paneModels.contains(where: {$0 === paneModel}) {
            paneModels.append(paneModel)
        }
    }
}
