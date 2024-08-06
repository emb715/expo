import ExpoFileSystem from './ExpoFileSystem';
import { Path } from './FileSystem.types';
export declare class File extends ExpoFileSystem.FileSystemFile {
    constructor(path: Path);
}
export declare class Directory extends ExpoFileSystem.FileSystemDirectory {
    constructor(path: Path);
}
export declare function write(file: File, contents: string): Promise<void>;
export declare function download(url: string, to: Directory | File): Promise<File>;
//# sourceMappingURL=FileSystem.d.ts.map