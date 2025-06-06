import React from 'react';
import { PlusIcon } from '@heroicons/react/24/outline';

const getCategoryColor = (category) => {
  const colors = {
    'Frutas y Verduras': 'bg-green-100 border-green-500',
    'Lácteos': 'bg-blue-100 border-blue-500',
    'Panadería': 'bg-yellow-100 border-yellow-500',
    'Carnes': 'bg-red-100 border-red-500',
    'Frágil': 'bg-purple-100 border-purple-500',
    'Congelados': 'bg-cyan-100 border-cyan-500',
    'Químicos': 'bg-amber-100 border-amber-500',
    'Limpieza': 'bg-teal-100 border-teal-500',
    'Pesado': 'bg-stone-100 border-stone-500',
    'Misceláneos': 'bg-gray-100 border-gray-500',
    'default': 'bg-gray-100 border-gray-500'
  };
  return colors[category] || colors.default;
};

function ItemList({ items, setDraggedItem, onAddItem }) {
  return (
    <div className="bg-white rounded-xl shadow-lg p-6">
      <div className="flex justify-between items-center mb-6">
        <h2 className="text-2xl font-bold text-gray-800">Artículos Disponibles</h2>
        <button
          onClick={onAddItem}
          className="flex items-center px-4 py-2 bg-indigo-500 text-white rounded-lg hover:bg-indigo-600 transition-colors"
        >
          <PlusIcon className="h-5 w-5 mr-2" />
          Nuevo Artículo
        </button>
      </div>
      <div className="grid grid-cols-1 sm:grid-cols-2 gap-4">
        {items.map((item, index) => (
          <div
            key={item.id || index}
            className={`p-4 rounded-lg border-2 transition-all transform hover:scale-105 cursor-pointer
              ${getCategoryColor(item.category)}`}
            draggable
            onDragStart={() => setDraggedItem(item.id || index)}
          >
            <div className="font-semibold text-gray-800">{item.name}</div>
            <div className="text-sm text-gray-600">{item.category}</div>
            <div className="text-sm font-medium text-gray-700">
              {item.weight} kg
            </div>
          </div>
        ))}
        {items.length === 0 && (
          <div className="col-span-2 text-center py-8 text-gray-400">
            No hay artículos disponibles. Agrega algunos con el botón "Nuevo Artículo".
          </div>
        )}
      </div>
    </div>
  );
}

export default ItemList;