class Academia {
	var property inventario = #{}
	method tengoCosa(cosa) = inventario.any({mueble=>mueble.tengoCosa(cosa)})
	method puedoGuardar(cosa) = ( !(inventario.any({mueble=>mueble.tengoCosa(cosa)})) ) and ( inventario.any({mueble=>mueble.puedoGuardar(cosa)}) )	
	method enDondeGuardo(cosa) = (inventario.filter({mueble=>mueble.puedoGuardar(cosa)})).asSet()
	method unoQueGuarde(cosa) = inventario.find({mueble=>mueble.puedoGuardar(cosa)})
	method guardarCosa(cosa) { if (!self.puedoGuardar(cosa)) {self.error("No puede!")} 
		else {(self.unoQueGuarde(cosa)).guardarCosa(cosa)}
	}
	method removerCosa(cosa) = {inventario.forEach({mueble=>mueble.removerCosa(cosa)})}
	method cosasMenosUtiles() = (inventario.map({mueble=>mueble.cosaMenosUtil()})).asSet()
	method marcasMenosUtil() = (inventario.map({mueble=>mueble.marcaMenosUtil()})).asSet()
	method marcaMenosUtil() = (self.marcasMenosUtil()).min({marca=>marca.aporte(cosa)})
	method removerCosasMenosUtil() {inventario.forEach({mueble=>mueble.removerCosa(mueble.cosaMenosUtil())})}
	method hayCosasMenosUtilYMagicas() = inventario.any({mueble=> (mueble.cosaMenosUtil()).esMagico()})
	method cualesCosasMenosUtilYMagicas() { if (!self.hayCosasMenosUtilYMagicas()) {self.error("No hay")} 
	else {return (inventario.filter({mueble=> (mueble.cosaMenosUtil()).esMagico()})).asSet()}
		}
	method removerCosasMenosUtilYMagicas() { if (inventario.size()<3) {self.error("No se puede")} 
		else 
		{(self.cualesCosasMenosUtilYMagicas()).forEach({cosa=>self.removerCosa(cosa)})}
	}
	method removerMueble(mueble) {inventario.remove(mueble)} 
}
class Cosa {
	var property volumen
	var property marca
	var property esMagico
	var property esReliquia
	method utilidad() {
		if (esMagico and esReliquia) {return volumen + marca.aporte(self) + 7}
		if (esMagico and !esReliquia) {return volumen + marca.aporte(self) + 3}
		if (esReliquia and !esMagico){return volumen + marca.aporte(self) + 5}
		else { return volumen + marca.aporte(self)}
		} 
}
class Mueble {
	var property cosas = #{}
	var property capacidadMaxima = 0
	method precio()
	method utilidad() = (( cosas.sum({cosa=>cosa.utilidad()}) ) / self.precio())
	method tengoCosa(cosa) = cosas.any({cos=>cos==cosa})
	method puedoGuardar(cosa)
	method removerCosa(cosa) {cosas.remove(cosa)}
	method capacidadDeAlgo(cosa) 
	method capacidadUsada() = cosas.sum({cosa=>(cosa.volumen())})
	method marcaMenosUtil() = (self.cosaMenosUtil()).marca()
	method cosaMenosUtil() = cosas.min({cosa=>cosa.utilidad()})
	method guardarCosa(cosa){if (!self.puedoGuardar(cosa)){
		self.error("No se puede cargar")}
		else {cosas.add(cosa)}
		}
}
class Baul inherits Mueble {
	override method precio() = capacidadMaxima + 2
	override method capacidadDeAlgo(cosa) = cosa.volumen()
	override method puedoGuardar(cosa) = ( ( (self.capacidadDeAlgo(cosa) + self.capacidadUsada()) <= capacidadMaxima) and (cosas.all({cos=> cosa != cos})) )
	override method utilidad() {
		if (cosas.all({cosa=>cosa.esReliquia()})) {return super()+2}
		else {return super()}
	}
}
class BaulMagico inherits Baul {
	override method precio() = super() * 2
	method cuantasCosasMagicas() = cosas.count({cosa=>cosa.esMagico()})
	override method utilidad() = super() + self.cuantasCosasMagicas()
}
class GabineteMagico inherits Mueble {
	override method precio() = 6
	override method guardarCosa(cosa) {if (cosa.esMagico()) {cosas.add(cosa)}}
	override method puedoGuardar(cosa) = ( (cosa.esMagico()) and (cosas.all({cos=> cosa != cos})) )
}
class ArmarioConvencional inherits Mueble {
	method cambiarCapacidad(capacidad) {capacidadMaxima = capacidad}
	override method precio() = 5 * capacidadMaxima 
	override method capacidadDeAlgo(cosa) = 1
	override method capacidadUsada() = cosas.size()
	override method puedoGuardar(cosa) = ( ( (self.capacidadDeAlgo(cosa) + self.capacidadUsada()) <= capacidadMaxima) and (cosas.all({cos=> cosa != cos})) )
}
class Marca {
	method aporte(cosa)
}
object acme inherits Marca {
	override method aporte(cosa) = (cosa.volumen())/2
}
object fenix inherits Marca {
	override method aporte(cosa) {if (cosa.esReliquia()) {return 3} else {return 0} }
}
object cuchuflito inherits Marca {
	override method aporte(cosa) =	0
}



