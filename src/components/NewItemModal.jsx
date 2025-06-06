import React, { useState } from 'react';
import { XMarkIcon } from '@heroicons/react/24/outline';

function NewItemModal({ onClose, onSubmit }) {
  const [name, setName] = useState('');
  const [category, setCategory] = useState('produce');
  const [weight, setWeight] = useState('');
  const [error, setError] = useState('');

  const categories = [
    { value: 'produce', label: 'Frutas y Verduras' },
    { value: 'dairy', label: 'Lácteos' },
    { value: 'meat', label: 'Carnes' },
    { value: 'bakery', label: 'Panadería' },
    { value: 'fragile', label: 'Frágil' },
    { value: 'frozen', label: 'Congelados' },
    { value: 'chemicals', label: 'Químicos' },
    { value: 'cleaning', label: 'Limpieza' },
    { value: 'heavy', label: 'Pesado' },
    { value: 'misc', label: 'Misceláneos' }
  ];

  const handleSubmit = (e) => {
    e.preventDefault();
    
    if (!name.trim()) {
      setError('El nombre es obligatorio');
      return;
    }
    
    const weightValue = parseFloat(weight);
    if (isNaN(weightValue) || weightValue <= 0) {
      setError('El peso debe ser un número mayor que cero');
      return;
    }
    
    onSubmit({ name, category, weight: weightValue });
    onClose();
  };

  return (
    <div className="fixed inset-0 bg-black bg-opacity-50 flex items-center justify-center z-50">
      <div className="bg-white rounded-lg shadow-xl w-full max-w-md">
        <div className="flex justify-between items-center p-4 border-b">
          <h2 className="text-xl font-semibold text-gray-800">Agregar Nuevo Artículo</h2>
          <button 
            onClick={onClose}
            className="text-gray-500 hover:text-gray-700"
          >
            <XMarkIcon className="h-6 w-6" />
          </button>
        </div>
        
        <form onSubmit={handleSubmit} className="p-4">
          {error && (
            <div className="mb-4 p-2 bg-red-100 text-red-700 rounded">
              {error}
            </div>
          )}
          
          <div className="mb-4">
            <label htmlFor="name" className="block text-sm font-medium text-gray-700 mb-1">
              Nombre
            </label>
            <input
              type="text"
              id="name"
              value={name}
              onChange={(e) => setName(e.target.value)}
              className="w-full p-2 border border-gray-300 rounded focus:ring-indigo-500 focus:border-indigo-500"
              placeholder="Ej: Manzanas"
            />
          </div>
          
          <div className="mb-4">
            <label htmlFor="category" className="block text-sm font-medium text-gray-700 mb-1">
              Categoría
            </label>
            <select
              id="category"
              value={category}
              onChange={(e) => setCategory(e.target.value)}
              className="w-full p-2 border border-gray-300 rounded focus:ring-indigo-500 focus:border-indigo-500"
            >
              {categories.map(cat => (
                <option key={cat.value} value={cat.value}>{cat.label}</option>
              ))}
            </select>
          </div>
          
          <div className="mb-4">
            <label htmlFor="weight" className="block text-sm font-medium text-gray-700 mb-1">
              Peso (kg)
            </label>
            <input
              type="number"
              id="weight"
              value={weight}
              onChange={(e) => setWeight(e.target.value)}
              step="0.1"
              min="0.1"
              className="w-full p-2 border border-gray-300 rounded focus:ring-indigo-500 focus:border-indigo-500"
              placeholder="Ej: 0.5"
            />
          </div>
          
          <div className="flex justify-end space-x-2">
            <button
              type="button"
              onClick={onClose}
              className="px-4 py-2 border border-gray-300 rounded text-gray-700 hover:bg-gray-50"
            >
              Cancelar
            </button>
            <button
              type="submit"
              className="px-4 py-2 bg-indigo-600 text-white rounded hover:bg-indigo-700"
            >
              Agregar
            </button>
          </div>
        </form>
      </div>
    </div>
  );
}

export default NewItemModal;