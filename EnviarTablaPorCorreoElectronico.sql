--CREO EL GRUPO DE ACCIONES QUE ME GENERARAN LA TABLA QUE DESEO ENVIAR POR CORREO
--TRATAR SIEMPRE QUE ESTA TABLA TENGA JUSTO EL FORMATO Y LAS COLUMNAS QUE DESEO ENVIAR POR CORREO ELECTRONICO

insert into ExistenciasAnterior select * from Existencias
delete from Existencias
insert into Existencias select * from COMPACTO_PLANTA_HAB.dbo.Existencia 
                      where Existencia_Actual>0 and 
                      (Id_Producto like '32133%' or Id_Producto like '32134%' or
					  Id_Producto like '32135%' or Id_Producto like '32136%')
drop table Diferencias;
select total.Id_Producto, pr.Desc_Producto, pr.UM_Almacen, total.Entrada into Diferencias from ( select Ex.Id_Producto,  Ex.Existencia_Actual - IsNull(ExA.Existencia_Actual,0) as Entrada from Existencias Ex left join ExistenciasAnterior ExA on Ex.Id_Producto = ExA.Id_Producto where Ex.Existencia_Actual-ISNULL(ExA.Existencia_Actual,0)>0  ) as total inner join COMPACTO_PLANTA_HAB.dbo.Producto pr on total.Id_Producto = pr.Id_Producto
--LA TABLA DIFERENCIAS ES LA QUE ESTOY CREANDO PARA EXPORTARLAS

--ESTE ES EL ASUNTO DEL CORREO QUE SE ENVIARA
declare @Asunto varchar(200);
set @Asunto =  'Reporte de entrada de papel al almacen '+convert(varchar(50),getdate(),120);

--ESTAS VARIABLES PERMITIRAN LA CREACION DE LA TABLA
 DECLARE @Body NVARCHAR(MAX), --CUERPO DEL CORREO
    @TableHead VARCHAR(1000), --ENCABEZADO HTML DE LA TABLA 
    @TableTail VARCHAR(1000)  --TERMINACION HTML DE LA TABLA



SET @TableTail = '</table></body></html>' ;
SET @TableHead = '<html><head>' + '<style>'
    + 'td {border: solid black;border-width: 1px;padding-left:5px;padding-right:5px;padding-top:1px;padding-bottom:1px;font: 11px arial} '
    + '</style>' + '</head>' + '<body>' + 
    + ' <br> <table cellpadding=0 cellspacing=0 border=0>' 
    + '<tr> <td bgcolor=#E6E6FA><b>Id Producto</b></td>'
    + '<td bgcolor=#E6E6FA><b>Descripcion del producto</b></td>'
    + '<td bgcolor=#E6E6FA><b>UM</b></td>'
	+ '<td bgcolor=#E6E6FA><b>Entrada</b></td></tr>';

SET @Body = ( SELECT    td = P.Id_Producto, '',
                        td = P.Desc_Producto, '',
                        td = P.UM_Almacen, '',
                        td = P.Entrada, ''
              FROM basesAuxiliares.dbo.Diferencias P     
			  FOR   XML RAW('tr'),
                  ELEMENTS
            )



SELECT  @Body ='<h2>Reporte de entrada de papel al almacen</h2><br><br>'+ @TableHead 
                + ISNULL(@Body, '') + @TableTail +
				'<br><br><br><p>Atentamente,</p><br><br>Sistema Informativo de Compacto Caribe S.A'
declare @CantidadEntrada int =  0;
set @CantidadEntrada = (select COUNT(*) from basesAuxiliares.dbo.Diferencias );

if (@CantidadEntrada>0) -- SE REALIZA ESTA COMPARACION PARA ENVIAR EL CORREO SOLO CUANDO EXISTAN REGISTROS EN LA TABLA
         begin

			EXEC msdb.dbo.sp_send_dbmail
				 @profile_name = 'Compacto Planta Habana', --NOMBRE DEL PROFILE QUE SE HA CREADO EN SQL SERVER
				 @recipients = 'yoennis.pavon@compacto.co.cu', --CORREOS A LOS QUE QUIERO ENVIARSELOS
				 @subject =@Asunto, -- ASUNTO DEL MENSAJE
				 @body = @Body, -- CUERPO DEL MENSAJE
				 @body_format ='HTML'; --MUY IMPORTANTE. ES AQUI DONDE SE DICE EL FORMATO DEL FICHERO
         END

