
//  ContentView.swift
//  WeSplit
//
//  Created by Paul Hudson on 07/10/2023.
//  Modified by Leandro Vansan on 21.01.2024
//


import SwiftUI

struct ContentView: View {
	@State private var valorDaConta = 0.0
	@State private var numeroAdultos = 0
	@State private var numeroCriancas = 0
	@State private var taxaServico = 0
	@FocusState private var valorInserido: Bool
	// MARK: picker variables
	let taxaPorcentagem = [0, 10, 15, 20, 25]
	// MARK: value per person
	var totalPorPessoa: Double {
		let pessoas = Double(numeroAdultos + 2) + Double(numeroCriancas)

		let taxaEscolhida = Double(taxaServico)
		let calContaTaxa = valorDaConta / 100 * taxaEscolhida
		let saldoPrevio = valorDaConta + calContaTaxa

		let totalDaContaPorPessoa = saldoPrevio / pessoas
		return totalDaContaPorPessoa
	}
	// MARK: calc children
	var totalPorCrianca: Double {
		let metadeValor = (totalPorPessoa / 2)
		return metadeValor
	}
	// MARK: calc children half value
	var totalDasCrianca: Double {
		let metadeValor = ((totalPorPessoa / 2) * Double(numeroCriancas))
		return metadeValor
	}
	// MARK: calc adults
	var totalDosAdultos: Double {
		let valorResto = ((totalDasCrianca) + (totalPorPessoa * Double(numeroAdultos + 2)))
		let valorFinalPorAdulto = valorResto / Double(numeroAdultos + 2)
		return valorFinalPorAdulto
	}
	// MARK: calc adults plus the rest (half value children)
	var valorFinalConta: Double {
		let taxaEscolhida = Double(taxaServico)
		let calContaTaxa = valorDaConta / 100 * taxaEscolhida
		let saldoPrevio = valorDaConta + calContaTaxa
		return saldoPrevio
	}

	var body: some View {
		NavigationStack {
			Form {
				//title, value, people, children
				Section {
					TextField("Valor da Conta", value: $valorDaConta, format: .currency(code: Locale.current.currency?.identifier ?? "USD"))
						.foregroundColor(.red)
						.font(.title).bold()
						.keyboardType(.decimalPad)
						.focused($valorInserido)

					Picker("Número de adultos", selection: $numeroAdultos) {
						ForEach(2..<100) {
							Text("\($0) adultos")
						}
					}

					Picker("Número de crianças", selection: $numeroCriancas) {
						ForEach(0..<100) {
							Text("\($0) crianças")
						}
					}
				}
				//picker to value tax
				Section("Quanto de gorjeta ou taxa de serviço?") {
					Picker("Porcentagem", selection: $taxaServico) {
						ForEach(taxaPorcentagem, id: \.self) {
							Text($0, format: .percent)
						}
					}
					.pickerStyle(.segmented)
				}
				// results
				Section ("Valor com taxa e dividido") {
					VStack {
						HStack {
							Text("Valor por adulto")
							Spacer()
							Text(totalDosAdultos, format: .currency(code: Locale.current.currency?.identifier ?? "USD"))
						}
						.foregroundColor(.blue)
						.font(.callout).bold()
						.padding(8)

						HStack {
							Text("Valor por criança")
							Spacer()
							if $numeroCriancas.wrappedValue > 0 {
								Text(totalPorCrianca, format: .currency(code: Locale.current.currency?.identifier ?? "USD"))
							} else {
								Text("-")
							}
						}
						.foregroundColor(.yellow)
						.font(.callout).bold()
						.padding(8)

						// MARK: - CODE WITH ERROR: "NO INDICATE CORRECTLY THE VALUE WHEN THE NUMBER OF ADULTS IS 3 OR 4 PEOPLE"

						//						HStack {
						//							Text("Valor por casal")
						//							Spacer()
						//							if $numeroAdultos.wrappedValue <= 2 {
						//								Text("-")
						//							} else {
						//								Text(totalDosAdultos * 2, format: .currency(code: Locale.current.currency?.identifier ?? "USD"))
						//							}
						//						}
						//						.foregroundColor(.gray)
						//						.font(.callout)
						//						.padding(8)
					}
				}
			}
			.navigationTitle("RachaConta")
			.navigationBarTitleDisplayMode(.large)

			.toolbar {
				if valorInserido {
					Button("OK") {
						valorInserido = false
					}
				}
			}
		}
	}
}

#Preview {
	ContentView()
}


