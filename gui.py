import tkinter as tk
from tkinter import ttk, messagebox
import subprocess
import re

class PackerGUI:
    def __init__(self, root):
        self.root = root
        self.root.title("Simulador de Empacador")
        
        # Estado de la aplicación
        self.bags = []
        self.items = []
        
        self.create_gui()
        self.load_initial_state()
    
    def create_gui(self):
        # Frame principal
        main_frame = ttk.Frame(self.root, padding="10")
        main_frame.grid(row=0, column=0, sticky=(tk.W, tk.E, tk.N, tk.S))
        
        # Panel izquierdo - Artículos disponibles
        items_frame = ttk.LabelFrame(main_frame, text="Artículos Disponibles", padding="5")
        items_frame.grid(row=0, column=0, padx=5, pady=5, sticky=(tk.W, tk.E, tk.N, tk.S))
        
        self.items_list = tk.Listbox(items_frame, height=15, width=40)
        self.items_list.grid(row=0, column=0, sticky=(tk.W, tk.E, tk.N, tk.S))
        items_scroll = ttk.Scrollbar(items_frame, orient=tk.VERTICAL, command=self.items_list.yview)
        items_scroll.grid(row=0, column=1, sticky=(tk.N, tk.S))
        self.items_list['yscrollcommand'] = items_scroll.set
        
        # Panel derecho - Bolsas
        bags_frame = ttk.LabelFrame(main_frame, text="Bolsas", padding="5")
        bags_frame.grid(row=0, column=1, padx=5, pady=5, sticky=(tk.W, tk.E, tk.N, tk.S))
        
        self.bags_text = tk.Text(bags_frame, height=15, width=40)
        self.bags_text.grid(row=0, column=0, sticky=(tk.W, tk.E, tk.N, tk.S))
        bags_scroll = ttk.Scrollbar(bags_frame, orient=tk.VERTICAL, command=self.bags_text.yview)
        bags_scroll.grid(row=0, column=1, sticky=(tk.N, tk.S))
        self.bags_text['yscrollcommand'] = bags_scroll.set
        
        # Panel de control
        control_frame = ttk.Frame(main_frame, padding="5")
        control_frame.grid(row=1, column=0, columnspan=2, pady=10)
        
        ttk.Label(control_frame, text="Bolsa #:").grid(row=0, column=0, padx=5)
        self.bag_number = ttk.Entry(control_frame, width=5)
        self.bag_number.grid(row=0, column=1, padx=5)
        
        ttk.Button(control_frame, text="Empacar", command=self.pack_item).grid(row=0, column=2, padx=5)
        ttk.Button(control_frame, text="Nueva Bolsa", command=self.new_bag).grid(row=0, column=3, padx=5)
        ttk.Button(control_frame, text="Actualizar", command=self.refresh_state).grid(row=0, column=4, padx=5)
    
    def load_initial_state(self):
        try:
            # Ejecutar el programa Mercury para obtener el estado inicial
            result = subprocess.run(['./empacador'], capture_output=True, text=True)
            self.parse_mercury_output(result.stdout)
        except Exception as e:
            messagebox.showerror("Error", f"Error al iniciar el programa: {str(e)}")
    
    def parse_mercury_output(self, output):
        # Limpiar las listas actuales
        self.items_list.delete(0, tk.END)
        self.bags_text.delete('1.0', tk.END)
        
        # Parsear la salida de Mercury
        items_section = False
        bags_section = False
        
        for line in output.split('\n'):
            if "ARTÍCULOS DISPONIBLES:" in line:
                items_section = True
                bags_section = False
                continue
            elif "BOLSAS:" in line:
                items_section = False
                bags_section = True
                continue
            elif "Comandos disponibles:" in line:
                break
            
            if items_section and line.strip().startswith('-'):
                self.items_list.insert(tk.END, line.strip())
            elif bags_section and line.strip():
                self.bags_text.insert(tk.END, line + '\n')
    
    def pack_item(self):
        try:
            selected_item = self.items_list.curselection()[0]
            item_text = self.items_list.get(selected_item)
            bag_num = self.bag_number.get()
            
            if not bag_num:
                messagebox.showerror("Error", "Por favor ingrese un número de bolsa")
                return
                
            # Aquí iría la lógica para comunicarse con Mercury
            # Por ahora solo actualizamos la interfaz
            self.refresh_state()
            
        except IndexError:
            messagebox.showerror("Error", "Por favor seleccione un artículo")
    
    def new_bag(self):
        # Aquí iría la lógica para crear una nueva bolsa en Mercury
        self.refresh_state()
    
    def refresh_state(self):
        self.load_initial_state()

if __name__ == "__main__":
    root = tk.Tk()
    app = PackerGUI(root)
    root.mainloop()