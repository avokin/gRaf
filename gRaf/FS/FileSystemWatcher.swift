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
            (stream: ConstFSEventStreamRef,
             contextInfo: Optional<UnsafeMutableRawPointer>,
             numEvents: Int,
             eventPaths: UnsafeMutableRawPointer,
             eventFlags: Optional<UnsafePointer<UInt32>>,
             eventIds: Optional<UnsafePointer<UInt64>>) in

            let mySelf = Unmanaged<FileSystemWatcher>.fromOpaque(_ : UnsafeRawPointer(contextInfo!)).takeUnretainedValue()
            let paths = unsafeBitCast(eventPaths, to: NSArray.self) as! [String]

            for paneModel in mySelf.paneModels {
                let modelPath = paneModel.getRootOriginalPath() + "/"

                if paths.contains(modelPath) {
                    paneModel.refresh()
                }
            }
        }

        fsEventStream = FSEventStreamCreate(nil, fileSystemObserverCallback, &context, pathsToWatch as CFArray,
                FSEventStreamEventId(kFSEventStreamEventIdSinceNow), CFTimeInterval(1.0),
                FSEventStreamCreateFlags(kFSEventStreamCreateFlagUseCFTypes))

        FSEventStreamScheduleWithRunLoop(fsEventStream!, CFRunLoopGetCurrent(), CFRunLoopMode.defaultMode!.rawValue)
        FSEventStreamStart(fsEventStream!)
    }

    func subscribeToFsEvents(_ paneModel: PaneModel) {
        if !paneModels.contains(where: {$0 === paneModel}) {
            paneModels.append(paneModel)
        }
    }
}
