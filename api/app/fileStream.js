'use strict';
import { createReadStream, createWriteStream } from 'fs';
import sizeof from 'object-sizeof';
const chunkMB = 2; // MB

const readFileStream = (filePath) => {

    console.log('[readFileStream]');

    return new Promise((resolve, reject) => {

        let chunks = [];
        let totalByte = 0;
        
        // Date 1 MB
        // base64 2.67 MB
        // ascii 2.00 MB
        // utf8 1.90 MB
        // utf16le, ucs2 1.00 MB
        // latin1, binary 2.00 MB
        // hex 4.00 MB

        let options = {
            'encoding': null,
            'highWaterMark': chunkMB * 1024 * 1024, 
        };
        let readStream = createReadStream(filePath, options);

        readStream.on('data', (chunk) => {

            chunks.push(chunk);
            totalByte += (sizeof(chunk) / (1024 * 1024));
            console.log("ReadStream", totalByte.toFixed(2), "MB");

        });

        readStream.on('end', () => {

            console.log("Path: " + filePath);
            console.log("ShowTotalByte: " + totalByte.toFixed(2) + "MB");
            console.log("ChunkLength:" + chunks.length);
            resolve(chunks)

        });
    });

};

const writeFileStream = (filePath, chunks) => {

    console.log('[writeFileStream]');

    return new Promise((resolve, reject) => {

        let totalByte = 0;
        let options = {
            'encoding': null,
            'highWaterMark': chunkMB * 1024 * 1024, 
        };
        let writeStream = createWriteStream(filePath, options);

        for (let i = 0; i < chunks.length; i++) {

            totalByte += sizeof(chunks[i]) / (1024 * 1024);
            writeStream.write(chunks[i]);

            console.log((totalByte).toFixed(2), "MB");
            
        };

        writeStream.end();
        writeStream.on('finish', () => {
            console.log('All writes are now complete.');
            resolve("WriteStream Done!!!");
        });

    });

};

export { readFileStream, writeFileStream };

// const run = async () => {
//     let chunks = await readFileStream('../fileUpload/test1.MOV');
//     console.log("ChunkLength: " + chunks.length);
//     let status = await writeFileStream('../fileDownload/test1.MOV', chunks);
//     console.log(status);
// };
// run()