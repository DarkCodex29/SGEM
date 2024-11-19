importScripts('https://unpkg.com/pdf-lib@1.17.1/pdf-lib.min.js');

// Escucha mensajes desde el hilo principal
self.onmessage = async function (event) {
  try {
    const { PDFDocument } = PDFLib; // Usa pdf-lib
    const { pages, nombreArchivo, rotar } = event.data; // Recibe datos del hilo principal

    if (!Array.isArray(pages) || pages.length === 0) {
      throw new Error('No se proporcionaron páginas para el PDF.');
    }

    const pdfDoc = await PDFDocument.create(); // Crea el documento PDF

    for (const pageContent of pages) {
      const pageToAdd = pdfDoc.addPage([595, 842]); // Tamaño A4

      // Agrega texto si está disponible
      if (pageContent.text) {
        const font = await pdfDoc.embedStandardFont(PDFLib.StandardFonts.Helvetica);
        const { height } = pageToAdd.getSize();
        pageToAdd.drawText(pageContent.text, {
          x: 50,
          y: height - 50,
          font,
          size: 12,
        });
      }

      // Agrega imagen si está disponible
      if (pageContent.image) {
        const imageBytes = rotar
          ? rotateImage(pageContent.image)
          : compressImage(pageContent.image);
        const image = await pdfDoc.embedPng(imageBytes); // Usa embedJpg si la imagen es JPG
        const { width, height } = image.scale(0.5); // Escala la imagen al 50%
        pageToAdd.drawImage(image, {
          x: 50,
          y: 300,
          width,
          height,
        });
      }
    }

    // Guarda el PDF como bytes
    const pdfBytes = await pdfDoc.save();
    self.postMessage({ pdfBytes, nombreArchivo }); // Envía el PDF al hilo principal
  } catch (error) {
    self.postMessage({ error: error.message }); // Envía el error al hilo principal
  }
};

// Comprimir una imagen con calidad ajustable
function compressImage(imageBytes) {
  // Implementar compresión usando una librería como `image-js` o lógica propia
  return imageBytes;
}

// Rotar una imagen 90 grados
function rotateImage(imageBytes) {
  // Implementar rotación usando `image-js` o lógica propia
  return imageBytes;
}
