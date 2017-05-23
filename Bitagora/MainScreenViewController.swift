//
//  MainScreenViewController.swift
//  ViewTest
//
//  Created by Lazaro Garcia Cruz on 26/4/17.
//  Copyright © 2017 Lazaro Garcia Cruz. All rights reserved.
//

import UIKit
import Gifu

public enum ScreenTouchPosition : Int {
    
    case izquierda
    case centro
    case derecha
    
}

class MainScreenViewController: UIViewController, UIGestureRecognizerDelegate,
                                UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout,
                                UITableViewDataSource, UITableViewDelegate {
    
    //La lista con los distintos juegos que el usuario gestiona
    private var games: Array<Game> = []
    
    public var isIphone = false
    private var needRelaod = true
    private var aplicacionIniciada = false

    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var viewScrolling: ScrollingBackgroundView!
    @IBOutlet weak var viewTitulo: RuneTextView!
    @IBOutlet weak var characterLista: GIFImageView!
    @IBOutlet weak var characterSwitch: GIFImageView!
    @IBOutlet weak var characterSpeechLista: GIFImageView!

    private var lastContentOffset: CGFloat = 0
    private var animate = false
    private var screenTouchPosition: ScreenTouchPosition = .centro

    let slideTransicion = SlideTransitionAnimator()
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        if UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiom.pad {
            isIphone = false
        } else {
            isIphone = true
        }
        
        cargarJuegos()
        
        inicializarViewControler()
        prepararCollectionView()
        prepararTabla()
        
    }
    
    /*
     Este metodo se llama cuando la vista se ha cargado y en el ejecutamos la animacion
     para la recarga de datos del collection view segun la extension añadida en la compilacion
    */
    override func viewDidAppear(_ animated: Bool) {
        
        if needRelaod {
            
            let randomNum: UInt32 = arc4random_uniform(4)
            
            if collectionView.isHidden {
                let direction = UITableView.UITableViewAnimationDirection(rawValue: Int(randomNum))
                self.tableView!.reloadWithAnimation(tableView: self.tableView, animationDirection: direction!)
            } else {
                let direction = UICollectionView.UICollectionViewAnimationDirection(rawValue: Int(randomNum))
                self.collectionView!.reloadWithAnimation(collectionView: self.collectionView, animationDirection: direction!)
            }
            
            needRelaod = false
            
        }
        
        if !aplicacionIniciada {
            animarBarraTitulo()
            aplicacionIniciada = true
        } else {
            viewScrolling.resumeBackground()
        }
        
    }
    
    /*
     Este metodo se llama cada vez que la vista va a desaparecer
     */
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        viewScrolling.pauseBackground()
    }
    
    /*
     Establece la barra de estado de color blanco
     */
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    /*
     Con este metodo estamos diciendo a la vista que se pueden usar varios gestos simultaneamente
     Para ello es necesario que implemente UIGestureRecognizerDelegate
    */
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
    
    /*
     Este metodo es el que realiza todos los pasos necesarios
     para inicializar los elementos visuales generales de la vista
     */
    func inicializarViewControler() {
        
        //Cambiamos el color de fondo de la status
        let colores: Array<CGColor> = [UIColor(red: 144/255, green: 42/255, blue: 135/255, alpha: 1).cgColor,
                                       UIColor(red: 252/255, green: 2/255, blue: 84/255, alpha: 1).cgColor]
        
        //Propiedades del status bar
        let statusBarView = UIView(frame: UIApplication.shared.statusBarFrame)
        statusBarView.createGradientWithColors(colors: colores, direction: .horizontal)
        view.addSubview(statusBarView)
        
        collectionView.isHidden = false
        tableView.isHidden = true
        
    }
    
    /*
     Este metodo en donde se van a realizar las tareas necesarias
     para cargar la lista de juegos que gestiona el usuario
     */
    func cargarJuegos() {
        
        let juego1 = Game(title: "The Legend of Zelda: Breath of the wild")
        juego1.logoImage = UIImage(named: "ZeldaLogo")
        juego1.coverImage = UIImage(named: "ZeldaBackground")
        
        var task = GameTask(title: "Como matar facilmente a los centaleones")
        task.difficulty = .hard
        task.priority = .high
    
        let component = TaskComponentText()
        component.texto = "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Pellentesque in lacinia eros. Morbi pulvinar orci a leo facilisis, in scelerisque quam sodales. Fusce blandit quam ac sapien gravida lacinia. Nam porttitor nec nibh ac imperdiet. Nulla rutrum imperdiet erat, a laoreet leo convallis quis. Morbi blandit dictum molestie. Vestibulum ex nisl, varius a pellentesque sed, lacinia ut sapien. Fusce eu mi ac odio placerat pulvinar sit amet ac massa. Vivamus bibendum, sapien non molestie blandit, neque purus tincidunt risus, ut finibus tortor augue id nulla. Nam commodo viverra egestas. Nullam neque nunc, feugiat vel volutpat at, dignissim sit amet metus. Fusce commodo maximus aliquam."
        
        task.listaComponentesTask.append(component)
        
        juego1.taskLista.append(task)
        
        task = GameTask(title: "Guia bestia divina del fuego")
        task.difficulty = .easy
        task.priority = .medium
        juego1.taskLista.append(task)
        task = GameTask(title: "Conseguir armadura zora1")
        task.difficulty = .normal
        task.priority = .high
        juego1.taskLista.append(task)
        task = GameTask(title: "Conseguir armadura zora2")
        task.difficulty = .hard
        task.priority = .low
        juego1.taskLista.append(task)
        task = GameTask(title: "Conseguir armadura zora3")
        task.difficulty = .normal
        task.priority = .medium
        juego1.taskLista.append(task)
        task = GameTask(title: "Conseguir armadura zora4")
        task.difficulty = .hard
        task.priority = .medium
        juego1.taskLista.append(task)
        task = GameTask(title: "Conseguir armadura zora5")
        juego1.taskLista.append(task)
        task = GameTask(title: "Conseguir armadura zora6")
        juego1.taskLista.append(task)
        task = GameTask(title: "Conseguir armadura zora7")
        juego1.taskLista.append(task)
        task = GameTask(title: "Conseguir armadura zora8")
        juego1.taskLista.append(task)
        task = GameTask(title: "Conseguir armadura zora9")
        juego1.taskLista.append(task)
        task = GameTask(title: "Conseguir armadura zora10")
        juego1.taskLista.append(task)
        task = GameTask(title: "Conseguir armadura zora11")
        juego1.taskLista.append(task)
        task = GameTask(title: "Conseguir armadura zora12")
        juego1.taskLista.append(task)
        task = GameTask(title: "Conseguir armadura zora13")
        juego1.taskLista.append(task)
        
        let juego2 = Game(title: "Dark Souls 3")
        juego2.logoImage = UIImage(named: "DarkSoulsLogo")
        juego2.coverImage = UIImage(named: "DarkSoulsBackground")
        
        let juego3 = Game(title: "Star Wars: Battlefront")
        juego3.logoImage = UIImage(named: "BattlefrontLogo")
        juego3.coverImage = UIImage(named: "BattlefrontBackground")
        
        let juego4 = Game(title: "Nier: Automata")
        juego4.logoImage = UIImage(named: "NierAutomataLogo")
        juego4.coverImage = UIImage(named: "NierAutomataBackground")
        
        games.append(juego1)
        games.append(juego2)
        games.append(juego3)
        games.append(juego4)
        games.append(juego1)
        games.append(juego2)
        games.append(juego2)
        games.append(juego3)
        games.append(juego4)
        games.append(juego2)
        games.append(juego1)
        games.append(juego4)
        games.append(juego3)
        games.append(juego2)
        games.append(juego4)
        
    }
    
    /*
     Este metodo se llama cada vez que se hace scroll sobre
     la vista principal y dependiendo de si el scroll es hacia
     arriba o hacia abajo se actualiza la animacion de las
     celdas tanto de la tabla como del collection
     */
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        if animate {
            
            if (self.lastContentOffset > scrollView.contentOffset.y) {
                // move up
                updateCells(-10)
            } else if (self.lastContentOffset < scrollView.contentOffset.y) {
                // move down
                updateCells(10)
            }
            
            self.lastContentOffset = scrollView.contentOffset.y
            
        }
        
    }
    
    /*
     Este metodo se llama cuando se empieza a arrastrar sobre el scroll
     */
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        animate = true
    }
    
    /*
     Este metodo se llama cuando se termina de arrastrar sobre el scroll
     */
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        animate = false
        updateCells(0)
    }
    
    /*
     En este metodo se actualizan la animacion de la celda
     tanto de la tabla como del collection en funcion de si
     el scroll es hacia arriba o abajo y dependiendo de en que
     parte de la pantalla ha pulsado el usuario
     */
    func updateCells(_ offset: CGFloat) {
        
        if collectionView.isHidden {
            for i in self.tableView.visibleCells {
                let cell: GameTableViewCell = i as! GameTableViewCell
                cell.animacionScroll(offset: offset, posicion: self.screenTouchPosition)
            }
        } else {
            for i in self.collectionView.visibleCells {
                let cell: GameCollectionViewCell = i as! GameCollectionViewCell
                cell.animacionScroll(offset: offset, posicion: self.screenTouchPosition)
            }
        }
        
    }
    
    /*
     Este metodo se llama cada vez que se pulsa el boton que permite
     alternar la visualizacion de los juegos en lista o en cuadricula
    */
    func cambiarOrganizacionListaJuegos() {

        characterLista.animate(withGIFNamed: "orc_attack_reverse.gif", loopCount: 1)
        characterSpeechLista.isHidden = true
        
        if tableView.isHidden == false {
            
            characterSwitch.image = UIImage(named: "switch_off")
            
            self.tableView.isUserInteractionEnabled = false
            self.tableView.layoutIfNeeded()
            
            let cells = self.tableView.visibleCells
            var index = 0
            var animationCompleted = 0
            let tableHeight: CGFloat = self.tableView.bounds.size.height
            
            for i in cells {
                
                let cell: UITableViewCell = i as UITableViewCell
                cell.transform = CGAffineTransform(translationX: 0, y: 0)
                
                UIView.animate(withDuration: 1, delay: 0.05 * Double(index), usingSpringWithDamping: 0.8, initialSpringVelocity: 0, options: .curveEaseIn, animations: {
                    cell.transform = CGAffineTransform(translationX: 0, y: -(tableHeight+cell.bounds.height))
                }, completion: {(exito) in
                    
                    animationCompleted += 1
                    if animationCompleted == cells.count {
                        self.tableView.isHidden = true
                        self.tableView.isUserInteractionEnabled = true
                        self.collectionView.isHidden = false
                        let randomNum: UInt32 = arc4random_uniform(4)
                        let direction = UICollectionView.UICollectionViewAnimationDirection(rawValue: Int(randomNum))
                        self.collectionView.reloadWithAnimation(collectionView: self.collectionView, animationDirection: direction!)
                        self.animate = false
                        self.characterLista.animate(withGIFNamed: "orc_idle.gif")
                        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                            self.characterSpeechLista.isHidden = false
                        }
                    }
                    
                })
                
                index += 1
                
            }
            
        } else {
            
            characterSwitch.image = UIImage(named: "switch_on")
            
            collectionView.isUserInteractionEnabled = false
            collectionView.layoutIfNeeded()
            
            let cells = collectionView.visibleCells
            var index = 0
            var animationCompleted = 0
            let tableHeight: CGFloat = collectionView.bounds.size.height
            
            for i in cells {
                
                let cell: UICollectionViewCell = i as UICollectionViewCell
                cell.transform = CGAffineTransform(translationX: 0, y: 0)
                
                UIView.animate(withDuration: 1, delay: 0.05 * Double(index), usingSpringWithDamping: 0.8, initialSpringVelocity: 0, options: .curveEaseIn, animations: {
                    cell.transform = CGAffineTransform(translationX: -tableHeight, y: 0)
                }, completion: {(exito) in
                    
                    animationCompleted += 1
                    if animationCompleted == cells.count {
                        self.collectionView.isHidden = true
                        self.collectionView.isUserInteractionEnabled = true
                        self.tableView.isHidden = false
                        self.tableView.isUserInteractionEnabled = true
                        self.tableView.reloadWithAnimation(tableView: self.tableView, animationDirection: UITableView.UITableViewAnimationDirection.up)
                        self.animate = false
                        self.characterLista.animate(withGIFNamed: "orc_idle.gif")
                        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                            self.characterSpeechLista.isHidden = false
                        }
                    }
                    
                })
                
                index += 1
                
            }
            
        }
        
    }
    
    /*
     Este metodo lleva a cabo las tareas necesarias para inicializar
     y gestionar las propiedades de la barra de titulo
    */
    func animarBarraTitulo() {
        
        characterLista.animate(withGIFNamed: "orc_idle.gif")
        characterSwitch.image = UIImage(named: "switch_on")
        characterSpeechLista.animate(withGIFNamed: "speechLista.gif")
        
        let characterListaHorizontal = characterLista.superview?.constraint(withIdentifier: "horizontalLista")
        let characterListaVertical = characterLista.superview?.constraint(withIdentifier: "verticalLista")
        let characterListaWidth = characterLista.constraint(withIdentifier: "widthLista")
        let characterListaHeight = characterLista.constraint(withIdentifier: "heightLista")
        
        let characterSwitchHorizontal = characterSwitch.superview?.constraint(withIdentifier: "horizontalSwitch")
        let characterSwitchVertical = characterSwitch.superview?.constraint(withIdentifier: "verticalSwitch")
        let characterSwitchWidth = characterSwitch.constraint(withIdentifier: "widthSwitch")
        let characterSwitchHeight = characterSwitch.constraint(withIdentifier: "heightSwitch")
        
        let characterSpeechListaHorizontal = characterSpeechLista.superview?.constraint(withIdentifier: "horizontalSpeechLista")
        let characterSpeechListaVertical = characterSpeechLista.superview?.constraint(withIdentifier: "verticalSpeechLista")
        let characterSpeechListaWidth = characterSpeechLista.constraint(withIdentifier: "widthSpeechLista")
        let characterSpeechListahHeight = characterSpeechLista.constraint(withIdentifier: "heightSpeechLista")
        
        var posBoton: CGFloat = 0
        
        if (isIphone) {
            
            characterListaHorizontal?.constant = 10
            characterListaVertical?.constant = -20
            characterListaWidth?.constant = 48
            characterListaHeight?.constant = 48
            
            characterSwitchHorizontal?.constant = 0
            characterSwitchVertical?.constant = -15
            characterSwitchWidth?.constant = 32
            characterSwitchHeight?.constant = 32
            
            characterSpeechListaHorizontal?.constant = -20
            characterSpeechListaVertical?.constant = -35
            characterSpeechListaWidth?.constant = 24
            characterSpeechListahHeight?.constant = 24
            
            posBoton = 20
            
        } else {
            
            characterListaHorizontal?.constant = 30
            characterListaVertical?.constant = -35
            characterListaWidth?.constant = 72
            characterListaHeight?.constant = 72
            
            characterSwitchHorizontal?.constant = 0
            characterSwitchVertical?.constant = -20
            characterSwitchWidth?.constant = 48
            characterSwitchHeight?.constant = 48
            
            characterSpeechListaHorizontal?.constant = -35
            characterSpeechListaVertical?.constant = -60
            characterSpeechListaWidth?.constant = 32
            characterSpeechListahHeight?.constant = 32
            
            posBoton = 90
            
        }
        
        let globalPoint = characterLista.superview?.convert(characterLista.frame.origin, to: nil)
        let boton = UIView(x: (globalPoint?.x)! - posBoton, y: (globalPoint?.y)! - 10, w: 140, h: 50)
        boton.backgroundColor = .clear
        boton.isUserInteractionEnabled = true
        self.view.addSubview(boton)
        self.view.bringSubview(toFront: boton)
        
        boton.addTapGesture(tapNumber: 1) { (gesture) in
            
            if !self.animate {
                self.cambiarOrganizacionListaJuegos()
            }
            
        }
        
        viewScrolling.animarBackground()
        
        let infoDictionary: NSDictionary = Bundle.main.infoDictionary as NSDictionary!
        let appName: NSString = infoDictionary.object(forKey: "CFBundleName") as! NSString
        viewTitulo.texto = (appName as String).uppercased()
        viewTitulo.animarTexto()
        
    }
    
    //------------------------------------------------------------------
    //------------------------------------------------------------------
    //------------------  METODOS DEL TABLE VIEW -----------------------
    //------------------------------------------------------------------
    //------------------------------------------------------------------
    
    /*
     Este metodo se encarga de establecer las propiedades de la tabla
    */
    func prepararTabla() {

        //Eliminamos el footer para que no se vean lineas de mas
        tableView.tableFooterView = UIView(frame: CGRect.zero)
        tableView.backgroundColor = .clear
        tableView.allowsSelection = true
        
        //Gestionamos la posicion de la tabla donde ha pulsado el usuario
        tableView.addPanGesture { (gesture) in
            
            let point = gesture.location(in: self.view)
            
            let limiteIzquierdo = self.view.bounds.width / 3
            let limiteDerecho = limiteIzquierdo * 2
            
            if point.x > 0 && point.x < limiteIzquierdo {
                self.screenTouchPosition = .izquierda
            } else if point.x > limiteIzquierdo && point.x < limiteDerecho {
                self.screenTouchPosition = .centro
            } else {
                self.screenTouchPosition = .derecha
            }
            
        }
        
        tableView.gestureRecognizers?[(tableView.gestureRecognizers?.count)!-1].delegate = self
        
        let tablaVertical = tableView.superview?.constraint(withIdentifier: "verticalTabla")
        
        if (isIphone) {
            tablaVertical?.constant = 30
        } else {
            tablaVertical?.constant = 50
        }
        
    }
    
    /*
     Devuelve el numero de filas de la tabla
     */
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return games.count
    }
    
    /*
     Este metodo configura la representacion visual de cada una de las filas de la tabla
     */
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "Game", for: indexPath) as! GameTableViewCell
        
        let juego = games[indexPath.row]
        cell.logoImage.image = juego.logoImage
        cell.backgroundImage.image = juego.coverImage
        cell.prepararCelda()
        cell.animacionScroll(offset: 0, posicion: .centro)
        cell.selectionStyle = .none
        
        let celdaSombraDerecha = cell.shadowMainView.superview?.constraint(withIdentifier: "derechaCeldaSombra")
        let celdaSombraIzquierda = cell.shadowMainView.superview?.constraint(withIdentifier: "izquierdaCeldaSombra")
        let celdaSombraArriba = cell.shadowMainView.superview?.constraint(withIdentifier: "arribaCeldaSombra")
        let celdaSombraAbajo = cell.shadowMainView.superview?.constraint(withIdentifier: "abajoCeldaSombra")
        
        let celdaCoverDerecha = cell.mainContentView.superview?.constraint(withIdentifier: "derechaCeldaCover")
        let celdaCoverIzquierda = cell.mainContentView.superview?.constraint(withIdentifier: "izquierdaCeldaCover")
        let celdaCoverArriba = cell.mainContentView.superview?.constraint(withIdentifier: "arribaCeldaCover")
        let celdaCoverAbajo = cell.mainContentView.superview?.constraint(withIdentifier: "abajoCeldaCover")
        
        if (isIphone) {
            celdaSombraDerecha?.constant = 15
            celdaSombraIzquierda?.constant = 15
            celdaSombraArriba?.constant = 0
            celdaSombraAbajo?.constant = 0
            celdaCoverDerecha?.constant = 35
            celdaCoverIzquierda?.constant = 35
            celdaCoverArriba?.constant = 20
            celdaCoverAbajo?.constant = 25
        } else {
            celdaSombraDerecha?.constant = 30
            celdaSombraIzquierda?.constant = 30
            celdaSombraArriba?.constant = 0
            celdaSombraAbajo?.constant = 0
            celdaCoverDerecha?.constant = 50
            celdaCoverIzquierda?.constant = 50
            celdaCoverArriba?.constant = 20
            celdaCoverAbajo?.constant = 25
            
        }
        
        return cell
        
    }
    
    /*
     Este metodo determina la altura de cada una de las filas de la tabla
    */
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        let totalFilas: CGFloat = 5.5
        return UIScreen.main.bounds.height / totalFilas/*(isIphone ? totalFilas + 2 : totalFilas + 2)*/
        
    }
    
    //------------------------------------------------------------------
    //------------------------------------------------------------------
    //----------------  METODOS DEL COLLECTION VIEW --------------------
    //------------------------------------------------------------------
    //------------------------------------------------------------------
    
    /*
     Este metodo se encarga de establecer las propiedades del collection view
    */
    func prepararCollectionView() {
        
        //Gestionamos la posicion del collection donde ha pulsado el usuario
        collectionView.addPanGesture { (gesture) in
            
            let point = gesture.location(in: self.view)
            
            let limiteIzquierdo = self.view.bounds.width / 3
            let limiteDerecho = limiteIzquierdo * 2
            
            if point.x > 0 && point.x < limiteIzquierdo {
                self.screenTouchPosition = .izquierda
            } else if point.x > limiteIzquierdo && point.x < limiteDerecho {
                self.screenTouchPosition = .centro
            } else {
                self.screenTouchPosition = .derecha
            }
            
        }
        
        collectionView.gestureRecognizers?[(collectionView.gestureRecognizers?.count)!-1].delegate = self
        
        let collectionIzquierda = collectionView.superview?.constraint(withIdentifier: "izquierdaCollection")
        let collectionDerecha = collectionView.superview?.constraint(withIdentifier: "derechaCollection")
        let collectionArriba = collectionView.superview?.constraint(withIdentifier: "arribaCollection")
        let collectionAbajo = collectionView.superview?.constraint(withIdentifier: "abajoCollection")
        
        if (isIphone) {
            collectionIzquierda?.constant = 15
            collectionDerecha?.constant = 15
            collectionArriba?.constant = 30
            collectionAbajo?.constant = 0
        } else {
            collectionIzquierda?.constant = 35
            collectionDerecha?.constant = 35
            collectionArriba?.constant = 50
            collectionAbajo?.constant = 0
        }
        
    }
    
    /*
     Determina el numero de items a mostrar en el collection view
     */
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return games.count
    }
    
    /*
     Determina la representacion de cada uno de los elementos del collection view
    */
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Game", for: indexPath) as! GameCollectionViewCell
        
        let juego = games[indexPath.row]
        cell.logoImage.image = juego.logoImage
        cell.backgroundImage.image = juego.coverImage
        cell.prepararCelda()
        cell.animacionScroll(offset: 0, posicion: .centro)
        
        let celdaSombraDerecha = cell.shadowMainView.superview?.constraint(withIdentifier: "derechaCeldaSombra")
        let celdaSombraIzquierda = cell.shadowMainView.superview?.constraint(withIdentifier: "izquierdaCeldaSombra")
        let celdaSombraArriba = cell.shadowMainView.superview?.constraint(withIdentifier: "arribaCeldaSombra")
        let celdaSombraAbajo = cell.shadowMainView.superview?.constraint(withIdentifier: "abajoCeldaSombra")
        
        let celdaCoverDerecha = cell.mainContentView.superview?.constraint(withIdentifier: "derechaCeldaCover")
        let celdaCoverIzquierda = cell.mainContentView.superview?.constraint(withIdentifier: "izquierdaCeldaCover")
        let celdaCoverArriba = cell.mainContentView.superview?.constraint(withIdentifier: "arribaCeldaCover")
        let celdaCoverAbajo = cell.mainContentView.superview?.constraint(withIdentifier: "abajoCeldaCover")
        
        if (isIphone) {
            celdaSombraDerecha?.constant = 0
            celdaSombraIzquierda?.constant = 0
            celdaSombraArriba?.constant = 0
            celdaSombraAbajo?.constant = 0
            celdaCoverDerecha?.constant = 20
            celdaCoverIzquierda?.constant = 20
            celdaCoverArriba?.constant = 20
            celdaCoverAbajo?.constant = 25
        } else {
            celdaSombraDerecha?.constant = 0
            celdaSombraIzquierda?.constant = 0
            celdaSombraArriba?.constant = 0
            celdaSombraAbajo?.constant = 0
            celdaCoverDerecha?.constant = 20
            celdaCoverIzquierda?.constant = 20
            celdaCoverArriba?.constant = 20
            celdaCoverAbajo?.constant = 25
        }
                
        return cell
        
    }
    
    /*
     En esta funcion determinamos el tamaño de la celda y la adaptamos segun el tamaño de la pantalla
    */
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        var numberOfItemsPerRow: Int = 2
        
        //Si el dispositivo donde se ejecuta la aplicacion es un
        //ipad entonces el numero de elementos por fila sera 3
        if !isIphone {
            numberOfItemsPerRow = 3
        }
        
        //let heightTolerance = 40
        
        //Con este codigo calculamos el ancho de la celda segun el numero de
        //item que queramos tener por fila, posteriormente la altura se calcula
        //de forma que mantenga una relacion determinada con respecto de la anchura
        
        let flowLayout = collectionViewLayout as! UICollectionViewFlowLayout
        let totalSpace = flowLayout.sectionInset.left
            + flowLayout.sectionInset.right
            + (flowLayout.minimumInteritemSpacing * CGFloat(numberOfItemsPerRow - 1))
        let width = Int((collectionView.bounds.width - totalSpace) / CGFloat(numberOfItemsPerRow))
        
        //return CGSize(width: width, height: (width*16)/9 - (heightTolerance*16/9))
        return CGSize(width: width, height: (width*255)/180)
        
    }
    
    //------------------------------------------------------------------
    //------------------------------------------------------------------
    //-----------------------  NAVEGACION ------------------------------
    //------------------------------------------------------------------
    //------------------------------------------------------------------
    
    /*
     Este metodo se ejecuta cada vez que se hace un transicion y nos permite
     determinar a quien se hace y que informacion se le envia
    */
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        let toViewController = segue.destination as! GameScreenViewController
        
        if segue.identifier == "tablaJuegosTransition" {
            if let indexPath = tableView.indexPathForSelectedRow {
                toViewController.juegoSeleccionado = games[indexPath.row]
            }
        } else if segue.identifier == "collectionJuegosTransicion" {
            if let indexPath = collectionView.indexPathsForSelectedItems?.first {
                toViewController.juegoSeleccionado = games[indexPath.row]
            }
        }
        
        toViewController.transitioningDelegate = slideTransicion
        
    }
    
    /*
     Este metodo se ejecuta cuando se vuelve a esta pantalla desde otra transicion
    */
    @IBAction func volverPantallaPrincipal(segue: UIStoryboardSegue) {
       
        
    }

}
