using System;
using System.Collections.Generic;
using System.Threading.Tasks;
using APIWithSql.Models;
using Microsoft.EntityFrameworkCore;
namespace APIWithSql.Data
{
    public class SpeakerEvalsRepository : iSpeakerEvalsRepository
    {
        private readonly ApplicationDbContext _context;

        public SpeakerEvalsRepository(ApplicationDbContext context)
        {
            _context = context;
        }

        public async Task<SpeakerEval> AddAsync(SpeakerEval item)
        {
            _context.Add(item);
            await _context.SaveChangesAsync();

            return item;
        }

        public async Task<SpeakerEval> FindAsync(int id)
        {
            return await _context.SpeakerEvaluations.FirstOrDefaultAsync(p => p.Id == id);
        }


        public IEnumerable<SpeakerEval> GetAll()
        {
            return _context.SpeakerEvaluations;
        }

        public async Task RemoveAsync(int id)
        {
            var entity = await _context.SpeakerEvaluations.SingleOrDefaultAsync(p => p.Id == id);
            if (entity == null)
                throw new InvalidOperationException("No Speaker EVals found matching id " + id);

            _context.SpeakerEvaluations.Remove(entity);
            await _context.SaveChangesAsync();
        }

        public async Task UpdateAsync(SpeakerEval se)
        {
            if (se == null)
                throw new ArgumentNullException(nameof(se));

            _context.SpeakerEvaluations.Update(se);
            await _context.SaveChangesAsync();
        }
    }
}
