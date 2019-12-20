USE [basesAuxiliares]
GO

/****** Object:  Table [dbo].[ConsolidandoVentas]    Script Date: 12/19/2019 10:00:25 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[ConsolidandoVentas](
	[IDClave] [int] IDENTITY(1,1) NOT NULL,
	[IDProducto] [varchar](50) NULL,
	[Desc_Producto] [varchar](200) NULL,
	[IDCliente] [varchar](50) NULL,
	[Desc_Cliente] [varchar](250) NULL,
	[Fabrica] [int] NULL,
	[Organismo] [varchar](50) NULL,
	[Ano] [int] NULL,
	[Mes] [int] NULL,
	[CantidadFacturada] [decimal](18, 2) NULL,
	[CantidadDevuelta] [decimal](18, 2) NULL,
	[ImporteFacturado] [decimal](18, 2) NULL,
	[ImporteDevuelto] [decimal](18, 2) NULL,
	[CantidadNeta]  AS ([CantidadFacturada]-[CantidadDevuelta]),
	[ImporteNeto]  AS ([ImporteFacturado]-[ImporteDevuelto]),
 CONSTRAINT [PK_ConsolidandoVentas] PRIMARY KEY CLUSTERED 
(
	[IDClave] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO

