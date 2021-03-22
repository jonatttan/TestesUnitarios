//
//  AvaliadorTests.swift
//  LeilaoTests
//
//  Created by Jonattan Moises Sousa on 22/03/21.
//  Copyright © 2021 Alura. All rights reserved.
//

import XCTest
@testable import Leilao

class AvaliadorTests: XCTestCase {
    
    private var jose, zeca, fabiola : Usuario!
    var leiloeiro:Avaliador!
    
    override func setUpWithError() throws {
       //Aqui configuramos ações antes de cada teste
        zeca = Usuario(nome: "Zeca")
        jose = Usuario(nome: "José")
        fabiola = Usuario(nome: "Fabiola")
        leiloeiro = Avaliador()
    }

    override func tearDownWithError() throws {
        //Ação desejada após cada teste, devem ser configuradas aqui.
    }
    
    func testDeveEntenderLeilaoComApenasUmLance() {
        let leilao = Leilao(descricao: "Play 4")
        leilao.propoe(lance: Lance(zeca, 1000.0))
        
        try? leiloeiro.avalia(leilao: leilao)
        
        XCTAssertEqual( 1000.0, leiloeiro.menorLance())
        XCTAssertEqual( 1000.0, leiloeiro.maiorLance())
    }
    
    func testeDeveEncontrarOsTresMaioresLances() {
        
        //Construção de teste usando Data Builder
        let leilao = CriadorDeLeilao().para(descricao: "Play 5")
            .lance(zeca, 300.0)
            .lance(fabiola, 400.0)
            .lance(zeca, 500.0)
            .lance(fabiola, 600.0).constroi()
        
        try? leiloeiro.avalia(leilao: leilao)
        
        
        let listaLances = leiloeiro.tresMaiores()
        
        XCTAssertEqual(3, listaLances.count)
        XCTAssertEqual(600.0, listaLances[0].valor)
        XCTAssertEqual(500.0, listaLances[1].valor)
        XCTAssertEqual(400.0, listaLances[2].valor)
    }

    func testeDeveIgnorarLeilaoSemLance() {
        let leilao = CriadorDeLeilao().para(descricao: "Playstation 15").constroi()
        
        XCTAssertThrowsError(try leiloeiro.avalia(leilao: leilao), "Não é possível avaliar um leilão sem lances") { (error) in
            print(error.localizedDescription)
        }
    }
}
