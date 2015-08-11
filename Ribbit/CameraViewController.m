//
//  CameraViewController.m
//  Ribbit
//
//  Created by Alex Valladares on 11/08/15.
//  Copyright (c) 2015 Alex Valladares. All rights reserved.
//

#import "CameraViewController.h"
// Importamos esta cabecera para las constantes del media type
#import <MobileCoreServices/UTCoreTypes.h>


@interface CameraViewController ()

@end

@implementation CameraViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Creamos la propiedad relacion y obtenemos el dato para el usuario logueado
    self.friendsRelation = [[PFUser currentUser] relationForKey:@"friendsRelations"];
    self.recipients = [[NSMutableArray alloc]init];
    
}

-(void)viewWillAppear:(BOOL)animated {
    // De nuevo insertamos el código en viewWillAppear (view lifecycle)
    
    [super viewWillAppear:animated];
    

    // Hacemos la consulta de la relacion
    PFQuery *query = [self.friendsRelation query];
    [query orderByAscending:@"username"];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (error) {
            NSLog(@"Error %@ %@", error, [error userInfo]);
            
            
        } else {
            // Volcamos los datos devueltos a un array (propiedad)
            self.friends = objects;
            [self.tableView reloadData];
        }
    }];
    
    // Solo mostramos el selector de fotos o la camara si no se ha seleccionado nada
    // sino, provoca que el selector se muestre una y otra vez
    
    if (self.image == nil && [self.videoFilePath length] == 0) {
        // Instanciamos nuestra propiedad UIImagePickerController
        self.imagePicker = [[UIImagePickerController alloc]init];
        // Hacemos que el delegado (la vista) del controlador sea CameraViewController (self)
        self.imagePicker.delegate = self;
        // Desactivamos la edición de imagenes
        self.imagePicker.allowsEditing = NO;
        // Maxima duracion para los videos (10 segundos)
        self.imagePicker.videoMaximumDuration = 10;
    
    
        if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]){
            // Obtenemos la camara como fuente de datos si tenemos cámara en el dispositivo
            self.imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
        } else {
            // Si no, establecemos el album de fotos como fuente de datos
            self.imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        }
    
        // Como tipo de datos, obtenemos los tipos disponibles para la fuente de datos seleccionada antes
        self.imagePicker.mediaTypes = [UIImagePickerController availableMediaTypesForSourceType:self.imagePicker.sourceType];
    
        // Presentamos esta vista de forma modal
        [self presentViewController:self.imagePicker animated:YES completion:nil];
    }

    
}



#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    // Return the number of rows in the section.
    return self.friends.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Celda" forIndexPath:indexPath];
    
    // Configure the cell...
    PFUser *user = [self.friends objectAtIndex:indexPath.row];
    cell.textLabel.text = user.username;
    
    // Si el usuario ya está en la lista de recipientes, marcamos el check
    // Si no, lo dejamos en blanco. Esto lo hacemos para "recargar" la lista
    // y que al reusar las celdas no hereden valores de otra pantalla..
    
    if ([self.recipients containsObject:user.objectId]) {
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
    } else {
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
    
    return cell;
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

-(void) imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    
    // Si pulsamos el botón de cancelar, cerramos el modal
    [self dismissViewControllerAnimated:YES completion:^{
        nil;
    }];
    
    // Y volvemos al tab inbox (indice 0)
    [self.tabBarController setSelectedIndex:0];
    
    
}

-(void) imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    
    NSString *mediaType = [info objectForKey:UIImagePickerControllerMediaType];
    
    // Según el tipo de medio
    if ([mediaType isEqualToString:(NSString*)kUTTypeImage]) {
        // Hemos tomado una foto o seleccionado una de la galería
        self.image = [info objectForKey:UIImagePickerControllerOriginalImage];
        // Si hemos tomado una foto, la guardamos en la galería
        if (self.imagePicker.sourceType == UIImagePickerControllerSourceTypeCamera) {
            // Guardamos la imagen
            UIImageWriteToSavedPhotosAlbum(self.image, nil, nil, nil);
            }
    } else if ([mediaType isEqualToString:(NSString*)kUTTypeVideo]) {
        // Guardamos la url del video grabado en nuestra propiedad videoFilePath
        NSURL *imagePickerURL = [info objectForKey:UIImagePickerControllerMediaURL];
        self.videoFilePath = [imagePickerURL path];
        if (self.imagePicker.sourceType == UIImagePickerControllerSourceTypeCamera) {
            // Guardamos el video si es compatible con el dispositivo
            if (UIVideoAtPathIsCompatibleWithSavedPhotosAlbum(self.videoFilePath)) {
                UISaveVideoAtPathToSavedPhotosAlbum(self.videoFilePath, nil, nil, nil);
            }
        }
    }
    

    // Cerramos el modal
    [self dismissViewControllerAnimated:YES completion:nil];

    
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    // Seleccionamos la celda pulsada
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    // Deseleccionamos la celda pulsada, si no se queda marcada
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    PFUser *user = [self.friends objectAtIndex:indexPath.row];
    
    // En el array de recipients guardaremos solo el id del usuario, en lugar
    // del usuario completo, que sería más costoso
    
    // Si no está marcado el recipiente, marcamos el check y lo añadimos al array
    // si está marcado, lo desmarcamos y lo borramos del array
    if (cell.accessoryType == UITableViewCellAccessoryNone) {
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
        [self.recipients addObject:user.objectId];
    } else if (cell.accessoryType == UITableViewCellAccessoryCheckmark){
        cell.accessoryType = UITableViewCellAccessoryNone;
        [self.recipients removeObject:user.objectId];
    }
    
}

#pragma mark - Acciones



// Boton cancelar

- (IBAction)cancel:(id)sender {
    
    // Si cancelamos, vaciamos los valores y volvemos al tab 0 (inbox)
    [self reset];
    [self.tabBarController setSelectedIndex:0];
}

- (IBAction)send:(id)sender {
    
    // Si no hemos seleccionado o capturado imagen o video, mostramos alerta y volvemos a cargar la vista
    
    if (self.image == nil && self.videoFilePath.length == 0) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Try again!" message:@"Please capture or select an image or video to send!" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
        [self presentViewController:self.imagePicker animated:YES completion:nil];
    } else {
        // Enviamos el mensaje y mostramos el inbox
        [self uploadMessage];
        [self.tabBarController setSelectedIndex:0];
    }
}

#pragma mark - Helper methods

- (void)reset {
    self.image = nil;
    self.videoFilePath = nil;
    [self.recipients removeAllObjects];
}

- (void) uploadMessage {
    
    NSData *fileData;
    NSString *fileName;
    NSString *fileType;

    // Comprobamos si es una imagen o un video
    
    if (self.image != nil) {
        // Comprimir la imagen
        UIImage *newImage = [self resizeImage:self.image toWidth:320.0f andHeight:480.0f];
        fileData = UIImagePNGRepresentation(newImage);
        fileName = @"image.png";
        fileType = @"image";
    } else {
        fileData = [NSData dataWithContentsOfFile:self.videoFilePath];
        fileName = @"video.mov";
        fileType = @"video";
    }
    
    PFFile *file = [PFFile fileWithName:fileName data:fileData];
    [file saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {

        if (error) {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"An error occurred!" message:@"Please try sending your message again!" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [alert show];
        } else {
            // Creamos el mensaje
            PFObject *message = [PFObject objectWithClassName:@"Messages"];
            
            [message setObject:file forKey:@"file"];
            [message setObject:fileType forKey:@"fileType"];
            [message setObject:self.recipients forKey:@"recipientsIds"];
            [message setObject:[[PFUser currentUser] objectId] forKey:@"senderId"];
            [message setObject:[[PFUser currentUser] username] forKey:@"senderName"];
            
            [message saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                if (error) {
                    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"An error occurred!" message:@"Please try sending your message again!" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
                    [alert show];
                } else {
                    // Todo ha ido bien reseteamos los datos
                    
                    [SVProgressHUD showSuccessWithStatus:@"Message sent!"];
                    [self reset];

                }
            }];
        }
    }];
    
}


-(UIImage*) resizeImage:(UIImage *)image toWidth:(float)width andHeight:(float)height {
    
    // Para redimensionar la imagen creamos un objeto CGSize (CoreGraphis) con las dimensiones que queremos
    CGSize newSize = CGSizeMake(width,height);
    // Creamos un rectangulo donde encuadrar la imagen
    CGRect newRectangle = CGRectMake(0,0,width,height);
    
    // Inicializamos el contexto
    UIGraphicsBeginImageContext(newSize);
    // Dibujamos dentro la imagen
    [image drawInRect:newRectangle];
    // Creamos otra imagen con la imagen redimensionada
    UIImage *resizedImage = UIGraphicsGetImageFromCurrentImageContext();
    // Cerramos el contexto
    UIGraphicsEndImageContext();
    
    // Devolvemos la imagen redimensionada
    return resizedImage;
    
}

@end
