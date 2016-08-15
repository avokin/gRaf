import Foundation

public class FileSystemWatcher {
    public static var instance: FileSystemWatcher = FileSystemWatcher();

    var paneModels: [PaneModel] = []

    public var fsEventStream: FSEventStreamRef? = nil

    init() {
        var context: FSEventStreamContext = FSEventStreamContext()
        context.version = 0;
        context.retain = nil;
        context.release = nil;
        context.copyDescription = nil;
        context.info = UnsafeMutablePointer<Void>(unsafeAddressOf(self))

        let paths = ["/"];
        let pathsToWatch = paths.map({ $0 as NSString }) as [AnyObject];

        let fileSystemObserverCallback: FSEventStreamCallback = {
            (stream: ConstFSEventStreamRef, contextInfo: UnsafeMutablePointer<Void>, numEvents: Int,
             eventPaths: UnsafeMutablePointer<Void>, eventFlags: UnsafePointer<FSEventStreamEventFlags>,
             eventIds: UnsafePointer<FSEventStreamEventId>) in
            let mySelf = Unmanaged<FileSystemWatcher>.fromOpaque(COpaquePointer(contextInfo)).takeUnretainedValue()
            let paths = unsafeBitCast(eventPaths, NSArray.self) as! [String]

            for paneModel in mySelf.paneModels {
                var modelPath = paneModel.getRoot().path + "/"

                modelPath = modelPath.substringFromIndex(modelPath.startIndex.advancedBy(1))
                if paths.contains(modelPath) {
                    paneModel.refreshCallback()
                }
            }
        }

        fsEventStream = FSEventStreamCreate(nil, fileSystemObserverCallback, &context, pathsToWatch,
                FSEventStreamEventId(kFSEventStreamEventIdSinceNow), CFTimeInterval(1.0),
                FSEventStreamCreateFlags(kFSEventStreamCreateFlagUseCFTypes))

        FSEventStreamScheduleWithRunLoop(fsEventStream!, CFRunLoopGetCurrent(), kCFRunLoopDefaultMode)
        FSEventStreamStart(fsEventStream!)
    }

    func subscribeToFsEvents(paneModel: PaneModel) {
        if !paneModels.contains({$0 === paneModel}) {
            paneModels.append(paneModel)
        }
    }
}