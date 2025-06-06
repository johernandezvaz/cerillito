import React from 'react';
import { XMarkIcon } from '@heroicons/react/24/outline';

function PackingRulesModal({ onClose }) {
  const rules = [
    {
      title: "Reglas Generales",
      items: [
        "Cada bolsa tiene un límite máximo de 5kg",
        "Los artículos de la misma categoría pueden empacarse juntos",
      ]
    },
    {
      title: "Incompatibilidades",
      items: [
        "Los químicos no pueden mezclarse con alimentos",
        "Los artículos pesados no deben empacarse con artículos frágiles",
        "Los productos de limpieza no deben mezclarse con alimentos"
      ]
    },
    {
      title: "Categorías de Alimentos",
      items: [
        "Frutas y Verduras",
        "Lácteos",
        "Carnes",
        "Panadería",
        "Congelados"
      ]
    }
  ];

  return (
    <div className="fixed inset-0 bg-black bg-opacity-50 flex items-center justify-center z-50">
      <div className="bg-white rounded-lg shadow-xl w-full max-w-2xl">
        <div className="flex justify-between items-center p-4 border-b">
          <h2 className="text-xl font-semibold text-gray-800">Reglas de Empaque</h2>
          <button 
            onClick={onClose}
            className="text-gray-500 hover:text-gray-700"
          >
            <XMarkIcon className="h-6 w-6" />
          </button>
        </div>
        
        <div className="p-6 space-y-6">
          {rules.map((section, index) => (
            <div key={index}>
              <h3 className="text-lg font-semibold text-gray-700 mb-3">
                {section.title}
              </h3>
              <ul className="list-disc pl-5 space-y-2">
                {section.items.map((item, itemIndex) => (
                  <li key={itemIndex} className="text-gray-600">
                    {item}
                  </li>
                ))}
              </ul>
            </div>
          ))}
        </div>

        <div className="border-t p-4 flex justify-end">
          <button
            onClick={onClose}
            className="px-4 py-2 bg-indigo-600 text-white rounded hover:bg-indigo-700"
          >
            Entendido
          </button>
        </div>
      </div>
    </div>
  );
}

export default PackingRulesModal;